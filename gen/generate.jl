# gen/generate.jl — Clang.jl binding generator for RDKit CFFI
#
# Usage:
#   cd RDKit.jl/gen/
#   jululia --project=.. generate.jl
#
# Prerequisites:
#   - Clang.jl installed (Pkg.add("Clang"))
#   - rdkit source tree at ../rdkit/ (for cffiwrapper.h)
#   - RDKit_jll available

using Clang.Generators
using RDKit_jll

cd(@__DIR__)

# The cffiwrapper.h is in the rdkit source tree
header_path = joinpath(dirname(pwd()), "..", "rdkit", "Code", "MinimalLib", "cffiwrapper.h")
headers = [normpath(header_path)]

# Include paths and defines for the C parser
rdkit_root = joinpath(dirname(pwd()), "..", "rdkit")
args = get_default_args()
push!(args, "-I$rdkit_root/Code")
push!(args, "-DRDKIT_RDKITCFFI_BUILD")
push!(args, "-DRDK_BUILD_INCHI_SUPPORT")  # InChI IS built in JLL
# Do NOT define RDK_BUILD_AVALON_SUPPORT — Avalon is NOT built in JLL

options = load_options(joinpath(@__DIR__, "generator.toml"))

# Create a stub export.h so Clang can parse the header
stub_dir = joinpath(@__DIR__, "stubs")
mkpath(stub_dir)
write(joinpath(stub_dir, "export.h"), """
// Stub for Clang.jl parsing — not used at runtime
#define RDKIT_EXPORT_API
#define RDKIT_IMPORT_API
""")
push!(args, "-I$stub_dir")

@info "Generating C bindings from" headers
ctx = create_context(headers, args, options)
build!(ctx)

println("✓ Generated src/ctypes.jl successfully")
