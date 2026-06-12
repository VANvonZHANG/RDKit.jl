# cxx_backend.jl — CxxWrap-based backend for RDKit C++ object access
#
# Loads libjlRDKit.so (produced by the jlRDKit wrapper project).
# Set JLRDKIT_LIB_PATH environment variable to the .so file path.
#
# Usage:
#   export JLRDKIT_LIB_PATH=/path/to/jlRDKit/build/lib/libjlRDKit.so
#   using RDKit
#   mol = RDKit.Cxx.smiles_to_mol("c1ccccc1")

module Cxx
    using CxxWrap
    using Libdl

    function _find_lib()
        # Check environment variable first
        env_path = get(ENV, "JLRDKIT_LIB_PATH", "")::String
        if !isempty(env_path) && isfile(env_path)
            return env_path
        end
        error("""
            libjlRDKit.so not found. Set JLRDKIT_LIB_PATH to the compiled library path:
              export JLRDKIT_LIB_PATH=/path/to/jlRDKit/build/lib/libjlRDKit.so
            Build it first: cd jlRDKit && julia --project=../jlRDKit_test gen/build.jl
        """)
    end

    @wrapmodule(_find_lib)

    function __init__()
        @initcxx
    end
end  # module Cxx
