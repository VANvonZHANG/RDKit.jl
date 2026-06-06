# RDKit.jl

[![CI](https://github.com/zhangfan/RDKit.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/zhangfan/RDKit.jl/actions/workflows/CI.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Julia wrapper for [RDKit](https://www.rdkit.org/) cheminformatics library, providing full coverage of the CFFI API (72 functions from RDKit 2026.03) through Clang.jl auto-generated bindings.

## Features

- **Molecule I/O** — Parse from SMILES/SMARTS/MolBlock, serialize to SMILES, SMARTS, CXSMILES, MolBlock (V2000/V3000), JSON, InChI, InChIKey
- **Reaction I/O** — Parse reactions from SMARTS, serialize to reaction SVG
- **6 Fingerprint Types** — Morgan, RDKit, Pattern, Atom Pair, Topological Torsion, MACCS keys (string and byte forms)
- **Molecular Descriptors** — Exact MW, AMW, LogP, TPSA, HBA, HBD, NumAtoms, NumHeavyAtoms, NumRotatableBonds, etc.
- **Substructure Search** — Single match and all-matches search with atom/bond mapping
- **Molecule Drawing** — SVG depiction for molecules and reactions, with substructure highlighting
- **Molecule Standardization** — Cleanup, normalize, neutralize, reionize, canonical tautomer, charge/fragment parent
- **2D/3D Coordinates** — Coordinate generation with CoordGen support and template alignment
- **Hydrogen Management** — Add/remove explicit hydrogens
- **Property CRUD** — Key-value metadata on molecules (set, get, list, clear, keep)
- **PNG Metadata** — Embed and extract molecule data in PNG images
- **Chirality Control** — Legacy stereo perception and non-tetrahedral chirality toggles
- **Logging** — Enable/disable RDKit logging, capture logs to buffer or tee to file

## Architecture

Three-layer design with automatic memory management:

```
┌──────────────────────────────────────────────────────────────┐
│  Layer 3: High-level Julia API (10 files)                    │
│  io.jl · drawing.jl · calculators.jl · standardization.jl   │
│  coordinates.jl · modification.jl · substructure.jl         │
│  properties.jl · png.jl · chirality.jl · logging.jl         │
├──────────────────────────────────────────────────────────────┤
│  Layer 2: Core types + API macros                            │
│  types.jl — Mol/Reaction structs with GC finalizers          │
│  api.jl   — @ccall_string / @ccall_bytes / @ccall_mutate!   │
├──────────────────────────────────────────────────────────────┤
│  Layer 1: Raw C bindings (ctypes.jl)                         │
│  Clang.jl auto-generated @ccall declarations → librdkitcffi  │
└──────────────────────────────────────────────────────────────┘
```

| Design Decision | Detail |
|----------------|--------|
| Molecule storage | Opaque serialized binary blob (`Cstring` + `Csize_t`) |
| Memory management | Julia GC finalizers call `free_ptr` automatically |
| Parameter passing | `Dict{String,Any}` → JSON string, matching RDKit CFFI convention |
| Mutation model | Standardization/coordinate/hydrogen functions modify `Mol` in-place |

## Quick Start

```julia
using RDKit

# --- Molecule I/O ---

mol = get_mol("c1ccccc1O")          # phenol from SMILES
smiles = get_smiles(mol)            # → "Oc1ccccc1"
molblock = get_molblock(mol)        # → V3000 MolBlock
inchi = get_inchi(mol)              # → InChI string
json_str = get_json(mol)            # → JSON representation

# --- Molecular Descriptors ---

desc = get_descriptors(mol)
println(desc["exactmw"])            # 94.041864818
println(desc["tpsa"])               # topological polar surface area

# --- Fingerprints ---

morgan = get_morgan_fp(mol, Dict("radius" => 2, "nBits" => 2048))
morgan_bytes = get_morgan_fp_as_bytes(mol, Dict("radius" => 2))

# --- Substructure Search ---

query = get_qmol("c1ccccc1")                          # benzene query
match = get_substruct_match(mol, query)                # first match
matches = get_substruct_matches(mol, query)            # all matches

# --- Molecule Drawing ---

svg = get_svg(mol)                                      # SVG string

# --- Standardization ---

cleanup(mol)                  # in-place cleanup
neutralize(mol)               # in-place neutralization
canonical_tautomer(mol)       # in-place tautomer canonicalization

# --- Coordinates ---

set_2d_coords(mol)            # generate 2D coordinates
set_3d_coords(mol, 42)        # generate 3D coordinates (seed=42)
has_coords(mol)               # check coordinate presence

# --- Hydrogen Management ---

add_hs(mol)                   # add explicit hydrogens (in-place)
remove_hs(mol)                # remove explicit hydrogens (in-place)

# --- Properties ---

set_prop!(mol, "name", "phenol")
get_prop(mol, "name")         # → "phenol"
has_prop(mol, "name")         # → true
clear_prop!(mol, "name")

# --- Reactions ---

rxn = get_rxn("Cc1ccccc1>>Cc1ccc(Br)cc1")
rxn_svg = get_rxn_svg(rxn)

# --- Version ---

version()                     # RDKit version string
```

## Comparison with RDKitMinimalLib.jl

| Feature | RDKitMinimalLib.jl | RDKit.jl |
|---------|--------------------|----------|
| RDKit version | 2022.09 | 2026.03 |
| CFFI function coverage | 45 / 47 | 72 / 72 |
| Binding generation | Hand-written ccall | Clang.jl auto-generated |
| Julia minimum | 1.6 | 1.10 |
| Property CRUD | ❌ | ✅ |
| PNG metadata embedding | ❌ | ✅ |
| Chirality control | ❌ | ✅ |
| Logging control | ❌ | ✅ |
| Automatic memory management | Manual | GC finalizers |

## API Reference

### Types

| Type | Description |
|------|-------------|
| `Mol` | Serialized molecule with GC-managed memory |
| `Reaction` | Serialized reaction with GC-managed memory |

### I/O

| Function | Signature | Description |
|----------|-----------|-------------|
| `get_mol` | `(str [, details]) → Mol?` | Parse molecule from SMILES/SMARTS/MolBlock |
| `get_qmol` | `(str [, details]) → Mol?` | Parse query molecule for substructure search |
| `get_rxn` | `(str [, details]) → Reaction?` | Parse reaction from SMARTS |
| `get_smiles` | `(mol [, details]) → String` | Canonical SMILES |
| `get_smarts` | `(mol [, details]) → String` | SMARTS |
| `get_cxsmiles` | `(mol [, details]) → String` | CXSMILES (with extended stereo) |
| `get_cxsmarts` | `(mol [, details]) → String` | CXSMARTS |
| `get_molblock` | `(mol [, details]) → String` | V3000 MolBlock |
| `get_v3kmolblock` | `(mol [, details]) → String` | Force V3000 |
| `get_v2kmolblock` | `(mol [, details]) → String` | Force V2000 |
| `get_json` | `(mol [, details]) → String` | JSON serialization |
| `get_inchi` | `(mol [, details]) → String` | InChI |
| `get_inchi_for_molblock` | `(molblock [, details]) → String` | InChI from MolBlock |
| `get_inchikey_for_inchi` | `(inchi) → String` | InChIKey from InChI |
| `get_mol_frags` | `(mol [, details]) → Vector{Mol}` | Split into fragments |

### Calculators

| Function | Description |
|----------|-------------|
| `get_morgan_fp` / `get_morgan_fp_as_bytes` | Morgan (circular) fingerprint |
| `get_rdkit_fp` / `get_rdkit_fp_as_bytes` | RDKit topological fingerprint |
| `get_pattern_fp` / `get_pattern_fp_as_bytes` | Pattern fingerprint (for substructure screening) |
| `get_atom_pair_fp` / `get_atom_pair_fp_as_bytes` | Atom pair fingerprint |
| `get_topological_torsion_fp` / `get_topological_torsion_fp_as_bytes` | Topological torsion fingerprint |
| `get_maccs_fp` / `get_maccs_fp_as_bytes` | MACCS keys (166 bits) |
| `get_descriptors` | Dict with `exactmw`, `amw`, `logp`, `tpsa`, `hba`, `hbd`, etc. |

### Standardization & Modification

| Function | Description |
|----------|-------------|
| `cleanup(mol)` | General cleanup |
| `normalize(mol)` | Functional group normalization |
| `neutralize(mol)` | Charge neutralization |
| `reionize(mol)` | Re-ionization |
| `canonical_tautomer(mol)` | Canonical tautomer |
| `charge_parent(mol)` | Charge parent |
| `fragment_parent(mol)` | Fragment parent (largest fragment) |
| `add_hs(mol)` | Add explicit hydrogens |
| `remove_all_hs(mol)` | Remove all explicit hydrogens |
| `remove_hs(mol)` | Remove explicit hydrogens |

### Coordinates & Drawing

| Function | Description |
|----------|-------------|
| `set_2d_coords(mol)` | Generate 2D coordinates |
| `set_2d_coords_aligned(mol, template_mol [, details])` | 2D coordinates aligned to template |
| `set_3d_coords(mol, seed)` | Generate 3D coordinates with random seed |
| `has_coords(mol)` | Check coordinate presence (0=none, 1=2D, 2=3D) |
| `prefer_coordgen(val)` | Prefer CoordGen over RDKit coord generator |
| `get_svg(mol [, details])` | SVG depiction |
| `get_rxn_svg(rxn [, details])` | Reaction SVG depiction |

### Substructure, Properties & PNG

| Function | Description |
|----------|-------------|
| `get_substruct_match(mol, query [, details])` | First substructure match |
| `get_substruct_matches(mol, query [, details])` | All substructure matches |
| `set_prop!(mol, key, val)` | Set molecule property |
| `get_prop(mol, key)` | Get molecule property |
| `has_prop(mol, key)` | Check property existence |
| `get_prop_list(mol)` | List all property keys |
| `clear_prop!(mol, key)` | Delete a property |
| `keep_props(mol, keys)` | Keep only specified properties |
| `add_mol_to_png_blob(mol, png_bytes)` | Embed molecule in PNG |
| `get_mol_from_png_blob(png_bytes)` | Extract molecule from PNG |
| `get_mols_from_png_blob(png_bytes)` | Extract all molecules from PNG |

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [RDKit_jll](https://github.com/JuliaBinaryWrappers/RDKit_jll.jl) | ≥ 2026.3 | Pre-built RDKit binaries with CFFI support |
| [JSON.jl](https://github.com/JuliaIO/JSON.jl) | ≥ 0.21 | Parameter serialization (`Dict` → JSON) |

No local RDKit installation required — all binaries are provided via JLL artifacts.

## Project Structure

```
RDKit.jl/
├── src/
│   ├── RDKit.jl              # Module definition, exports 61 public symbols
│   ├── ctypes.jl             # Layer 1: Raw C bindings
│   ├── types.jl              # Layer 2: Mol, Reaction structs
│   ├── api.jl                # Layer 2: @ccall_string / @ccall_bytes / @ccall_mutate!
│   ├── io.jl                 # Layer 3: Molecule/reaction I/O
│   ├── drawing.jl            # Layer 3: SVG generation
│   ├── calculators.jl        # Layer 3: Fingerprints & descriptors
│   ├── standardization.jl    # Layer 3: Molecule standardization
│   ├── coordinates.jl        # Layer 3: 2D/3D coordinates
│   ├── modification.jl       # Layer 3: Hydrogen add/remove
│   ├── substructure.jl       # Layer 3: Substructure matching
│   ├── properties.jl         # Layer 3: Property CRUD
│   ├── png.jl                # Layer 3: PNG metadata embedding
│   ├── chirality.jl          # Layer 3: Chirality settings
│   └── logging.jl            # Layer 3: Logging & version()
├── gen/
│   ├── generator.toml        # Clang.jl configuration
│   ├── generate.jl           # Binding generation script
│   └── prologue.jl           # Generated file header
├── test/
│   ├── runtests.jl           # Test runner
│   └── test_*.jl             # 11 test files, ~55+ test cases
├── docs/                     # Documentation (pending)
├── Project.toml              # Package metadata
└── .github/workflows/        # CI/CD automation
    ├── CI.yml                # Julia 1.10 + latest, ubuntu + macOS
    ├── TagBot.yml            # Automated releases
    ├── CompatHelper.yml      # Dependency compat checking
    └── JuliaFormatter.yml    # Code format enforcement
```

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

[MIT License](LICENSE). RDKit itself is distributed under the BSD-3-Clause license.
