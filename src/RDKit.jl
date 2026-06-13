module RDKit

using CxxWrap
using CxxWrap.StdLib: SharedPtrAllocated
import RDKit_jll
import Libdl

# ------------------------------------------------------------
# Set up the dynamic loader path BEFORE the Cxx submodule loads
# libjlRDKit.so.
#
# libjlRDKit.so links the RDKit_jll shared libraries directly, but those
# libraries (whose own RUNPATH is $ORIGIN) cannot resolve their boost
# dependencies (libboost_serialization.so etc., which live in a separate
# artifact dir). The fix is two-pronged:
#   1. Push the RDKit, JlCxx and boost lib dirs onto Base.DL_LOAD_PATH so
#      the loader can find every NEEDED library.
#   2. dlopen the boost libs (and the RDKit libs that pull them in) with
#      RTLD_GLOBAL so their symbols are available globally and the RDKit
#      libs' own NEEDED entries resolve at dlopen time.
#
# With this in place `using RDKit` works WITHOUT an externally-set
# LD_LIBRARY_PATH. If anything goes wrong (RDKit_jll unavailable, artifacts
# moved) we fall back gracefully and rely on JLRDKIT_LIB_PATH + external
# LD_LIBRARY_PATH.
# ------------------------------------------------------------

"""Locate the boost artifact dir by scanning the Julia artifacts root for a
`lib/libboost_serialization.so` file. Returns the boost lib dir or `nothing`."""
function _find_boost_libdir()
    artifacts_root = dirname(RDKit_jll.artifact_dir)
    isdir(artifacts_root) || return nothing
    for d in readdir(artifacts_root)
        cand = joinpath(artifacts_root, d, "lib", "libboost_serialization.so")
        isfile(cand) && return joinpath(artifacts_root, d, "lib")
    end
    return nothing
end

# Boost libraries that the RDKit_jll .so files list as NEEDED but cannot
# resolve on their own (their RUNPATH is $ORIGIN). Preloading these with
# RTLD_GLOBAL makes their symbols globally visible so the transitive link
# succeeds.
const _BOOST_PRELOAD = (
    "libboost_serialization.so",
    "libboost_iostreams.so",
    "libboost_random.so",
    "libboost_regex.so",
    "libboost_system.so",
)

# RDKit libraries that transitively pull boost in; preloading them with
# RTLD_GLOBAL (after boost) resolves the rest of the dependency graph.
const _RDKIT_PRELOAD = (
    "libRDKitGraphMol.so",
    "libRDKitFileParsers.so",
    "libRDKitSmilesParse.so",
    "libRDKitFingerprints.so",
    "libRDKitMolDraw2D.so",
)

"""Push a directory onto `Base.DL_LOAD_PATH` (idempotent, at the front)."""
function _push_load_path!(dir::AbstractString)
    isempty(dir) && return
    d = String(dir)
    d ∉ Base.DL_LOAD_PATH && pushfirst!(Base.DL_LOAD_PATH, d)
    return nothing
end

"""Preload a .so with RTLD_GLOBAL, ignoring failures (best-effort)."""
function _preload!(libpath::AbstractString)
    try
        Libdl.dlopen(libpath, Libdl.RTLD_GLOBAL)
    catch err
        @warn "Could not preload library" lib=libpath exception=err
    end
    return nothing
end

function _setup_load_path!()
    try
        # RDKit + JlCxx dirs.
        _push_load_path!(joinpath(RDKit_jll.artifact_dir, "lib"))
        _push_load_path!(joinpath(CxxWrap.prefix_path(), "lib"))

        # Boost dir + global preload of the boost libs the RDKit .so files
        # transitively need.
        boost_dir = _find_boost_libdir()
        if boost_dir !== nothing
            _push_load_path!(boost_dir)
            for lib in _BOOST_PRELOAD
                _preload!(joinpath(boost_dir, lib))
            end
        end

        # Preload the key RDKit libs globally so their own NEEDED entries
        # resolve against the now-global boost symbols.
        rdkit_libdir = joinpath(RDKit_jll.artifact_dir, "lib")
        for lib in _RDKIT_PRELOAD
            _preload!(joinpath(rdkit_libdir, lib))
        end
    catch err
        @warn "Could not fully set up RDKit load path" exception=err
    end
    return nothing
end

_setup_load_path!()

# ============================================================
# CxxWrap raw C++ types submodule
#
# The wrapped C++ module is exposed as `RDKit.Cxx`. The library is found
# via the JLRDKIT_LIB_PATH env var, falling back to jlRDKit_jll (when it
# exists in Phase 4).
# ============================================================
module Cxx
    using CxxWrap

    function _find_lib()
        lib_path = get(ENV, "JLRDKIT_LIB_PATH", "")
        if isempty(lib_path)
            # Lazily load jlRDKit_jll if it is installed (Phase 4). `import`
            # is not allowed inside a function, so resolve via the package
            # machinery.
            pkg = Base.identify_package("jlRDKit_jll")
            if pkg !== nothing
                jll = Base.require(Cxx, pkg)
                lib_path = jll.libjlRDKit
            else
                error("jlRDKit library not found. Set JLRDKIT_LIB_PATH or install jlRDKit_jll.")
            end
        end
        return lib_path
    end

    @wrapmodule(_find_lib)

    function __init__()
        @initcxx
    end
end

# ============================================================
# Julian wrapper layer
# ============================================================
include("types.jl")
include("io.jl")
include("atoms.jl")
include("properties.jl")
include("fingerprints.jl")
include("drawing.jl")

# ============================================================
# Exports
# ============================================================
export RWMol, ROMol, Atom, Bond
export smiles_to_mol, molblock_to_mol
export to_smiles, to_molblock
export atoms, bonds
export symbol, atomic_num, idx, order
export begin_atom_idx, end_atom_idx
export num_atoms, num_bonds, num_heavy_atoms
export morgan_fingerprint, rdkit_fingerprint
export to_svg

# ============================================================
# Runtime initialisation
#
# Once the C++ submodule has loaded, the wrapped types `Cxx.RWMol` /
# `Cxx.ROMol` exist and we can bind the user-facing `RWMol` / `ROMol` aliases
# to their concrete parametrised shared-pointer types. These are used for
# display and documentation (dispatch in the Julian API uses the statically
# known `SharedPtrAllocated`, see types.jl).
# ============================================================
function __init__()
    # Bind the user-facing molecule type aliases now that the C++ module has
    # loaded and registered its types. WrapIt names the wrapped C++ types with
    # their fully-qualified namespace (`RDKit!RWMol`), accessed via
    # `getproperty`. These aliases are for display/documentation; dispatch in
    # the Julian API uses the statically-known `SharedPtrAllocated` (types.jl).
    try
        cxx_rwmol = getproperty(Cxx, Symbol("RDKit!RWMol"))
        cxx_romol = getproperty(Cxx, Symbol("RDKit!ROMol"))
        @eval RDKit begin
            const RWMol = SharedPtrAllocated{$cxx_rwmol}
            const ROMol = SharedPtrAllocated{$cxx_romol}
        end
    catch err
        @warn "Could not bind RDKit molecule type aliases" exception=err
    end
    return nothing
end

end # module RDKit
