# Molecule I/O: SMILES and MolBlock.
#
# The shims accept the SharedPtrAllocated<RWMol> directly (CxxWrap converts a
# shared_ptr into the `const std::shared_ptr<RWMol>&` argument). See
# jlRDKit_test/test.jl: `mol_to_smiles(mol_ptr)` and `mol_to_molblock(mol)`.
#
# Methods dispatch on the unparametrized `SharedPtrAllocated` (see types.jl)
# so they are defined at parse time.

"""
    smiles_to_mol(smiles::AbstractString) -> RWMol

Parse a SMILES string into a mutable molecule.

```jldoctest
julia> mol = RDKit.smiles_to_mol("c1ccccc1");
```
"""
smiles_to_mol(smiles::AbstractString) = Cxx.smiles_to_mol(String(smiles))

"""
    molblock_to_mol(molblock::AbstractString) -> RWMol

Parse a MolBlock (V2000 or V3000) string into a mutable molecule.
"""
molblock_to_mol(molblock::AbstractString) = Cxx.molblock_to_mol(String(molblock))

"""
    to_smiles(mol::RWMol) -> String

Return the canonical SMILES for `mol`.
"""
to_smiles(mol::SharedPtrAllocated) = Cxx.mol_to_smiles(mol)

"""
    to_molblock(mol::RWMol) -> String

Serialize `mol` to a V2000 MolBlock string.
"""
to_molblock(mol::SharedPtrAllocated) = Cxx.mol_to_molblock(mol)
