# Atom and Bond traversal with GC safety.
#
# `mol_get_atoms` / `mol_get_bonds` are shims taking `const RDKit::ROMol&`,
# so the SharedPtrAllocated must be dereferenced with `mol[]` (mirrors
# jlRDKit_test/test.jl: `mol = mol_ptr[]; mol_get_atoms(mol)`). Each shim
# returns a `std::vector<const RDKit::Atom*>` (resp. `Bond*`); CxxWrap hands
# those back as pointers, and each element must be dereferenced with `[]`
# (the test does `getSymbol(atoms[1][])`). We capture that dereferenced
# pointer in the GC-safe `Atom`/`Bond` wrappers from types.jl.

"""
    atoms(mol::RWMol) -> Vector{Atom}

Return every atom in `mol` as a vector of GC-safe [`Atom`](@ref) wrappers.
Each wrapper holds a reference to its parent molecule.
"""
function atoms(mol::SharedPtrAllocated)
    raw_ptrs = Cxx.mol_get_atoms(mol[])
    return Atom[Atom(ptr[], mol) for ptr in raw_ptrs]
end

"""
    bonds(mol::RWMol) -> Vector{Bond}

Return every bond in `mol` as a vector of GC-safe [`Bond`](@ref) wrappers.
Each wrapper holds a reference to its parent molecule.
"""
function bonds(mol::SharedPtrAllocated)
    raw_ptrs = Cxx.mol_get_bonds(mol[])
    return Bond[Bond(ptr[], mol) for ptr in raw_ptrs]
end
