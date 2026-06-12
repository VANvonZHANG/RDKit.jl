module RDKit

using RDKit_jll
using JSON

# CxxWrap backend — direct C++ object access (requires libjlRDKit.so)
# Falls back gracefully if library not available (CFFI still works)
using Libdl
const _cxx_available = Ref(false)
const _srcdir = @__DIR__

function _try_init_cxx()
    try
        include(joinpath(_srcdir, "cxx_backend.jl"))
        # If we get here, the Cxx submodule loaded successfully
        _cxx_available[] = true
        return true
    catch e
        @debug "CxxWrap backend not available" exception = (e, catch_backtrace())
        return false
    end
end

# Layer 1: Raw ccall bindings for RDKit CFFI
include("ctypes.jl")

# Layer 2: Core types and API macros
include("types.jl")
include("api.jl")

# Layer 3: High-level Julia API
include("io.jl")
include("drawing.jl")
include("calculators.jl")
include("standardization.jl")
include("coordinates.jl")
include("modification.jl")
include("substructure.jl")
include("properties.jl")
include("png.jl")
include("chirality.jl")
include("logging.jl")

# Export public API
export # Types
       Mol, Reaction,
       # I/O
       get_mol, get_qmol, get_rxn,
       get_smiles, get_smarts, get_cxsmiles, get_cxsmarts,
       get_molblock, get_v3kmolblock, get_v2kmolblock,
       get_json, get_inchi, get_inchi_for_molblock, get_inchikey_for_inchi,
       get_mol_frags,
       # Drawing
       get_svg, get_rxn_svg,
       # Calculators
       get_morgan_fp, get_rdkit_fp, get_pattern_fp,
       get_atom_pair_fp, get_topological_torsion_fp, get_maccs_fp,
       get_morgan_fp_as_bytes, get_rdkit_fp_as_bytes, get_pattern_fp_as_bytes,
       get_atom_pair_fp_as_bytes, get_topological_torsion_fp_as_bytes, get_maccs_fp_as_bytes,
       get_descriptors,
       # Standardization
       cleanup, normalize, neutralize, reionize,
       canonical_tautomer, charge_parent, fragment_parent,
       # Coordinates
       prefer_coordgen, set_2d_coords, set_2d_coords_aligned, set_3d_coords, has_coords,
       # Modification
       add_hs, remove_all_hs, remove_hs,
       # Substructure
       get_substruct_match, get_substruct_matches,
       # Properties
       has_prop, get_prop, get_prop_list, set_prop!, clear_prop!, keep_props,
       # PNG
       add_mol_to_png_blob, get_mol_from_png_blob, get_mols_from_png_blob,
       # Chirality
       use_legacy_stereo_perception, allow_non_tetrahedral_chirality,
       # Logging & Utils
       enable_logging, disable_logging, enable_logger, disable_logger,
       set_log_tee, set_log_capture, get_log_buffer, clear_log_buffer, destroy_log_handle,
       version

function __init__()
    _try_init_cxx()
end

end # module
