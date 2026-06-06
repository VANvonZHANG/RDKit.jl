# RDKit.jl

Julia wrapper for [RDKit](https://www.rdkit.org/) cheminformatics library, providing full coverage of the CFFI API (72 functions) through Clang.jl auto-generated bindings.

## Architecture

Three-layer design:

| Layer | File | Purpose |
|-------|------|---------|
| Layer 1 | `ctypes.jl` | Auto-generated C bindings via Clang.jl |
| Layer 2 | `api.jl` + `types.jl` | Macros (`@ccall_string`, `@ccall_bytes`, `@ccall_mutate!`) and `Mol`/`Reaction` structs |
| Layer 3 | `io.jl`, `calculators.jl`, etc. | Julia-friendly high-level API |

## Quick Start

```julia
using RDKit

# Create a molecule from SMILES
mol = get_mol("c1ccccc1O")
@assert mol !== nothing

# Get SMILES back
smiles = get_smiles(mol)
println(smiles)  # "Oc1ccccc1"

# Calculate molecular descriptors
desc = get_descriptors(mol)
println(desc["exact_mw"])  # exact molecular weight

# Generate Morgan fingerprint
fp = get_morgan_fp(mol, Dict("radius" => 2, "nBits" => 2048))

# Substructure search
query = get_mol("c1ccccc1")
matches = get_substruct_match(mol, query)
```

## Dependencies

- **RDKit_jll** ≥ 2026.3 — Pre-built RDKit binaries with CFFI support
- **JSON** ≥ 0.21 — Parameter serialization

## Comparison with RDKitMinimalLib.jl

| Feature | RDKitMinimalLib.jl | RDKit.jl |
|---------|--------------------|----------|
| CFFI function coverage | 45/47 (2022.09) | 72/72 (2026.03) |
| Binding generation | Hand-written ccall | Clang.jl auto-generated |
| Missing modules | properties, png, chirality, logging | None |
| Julia minimum version | 1.6 | 1.10 |

## Development

### Regenerate C bindings

```bash
cd gen/
julia --project=.. generate.jl
```

### Run tests

```bash
julia --project -e 'using Pkg; Pkg.test()'
```

### Format code

```bash
julia -e 'using JuliaFormatter; format("src/")'
```

## License

MIT License. RDKit itself is distributed under the BSD-3-Clause license.
