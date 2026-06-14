# Atom, Bond and Molecule property accessors.
#
# The WrapIt-generated accessors (`getSymbol`, `getAtomicNum`, ...) operate on
# the dereferenced C++ object. `Atom.ptr` / `Bond.ptr` are already the
# dereferenced pointer produced in `atoms.jl`, so the accessor can be called
# directly on `atom.ptr`. The molecule accessor shims (`getNumAtoms`, ...)
# take `const ROMol&`, so the SharedPtrAllocated is dereferenced with `mol[]`
# (mirrors jlRDKit_test: `getNumAtoms(mol[])`).

# ---- Atom properties ----

"""
    symbol(atom::Atom) -> String

Return the element symbol of `atom` (e.g. `"C"`, `"O"`).
"""
symbol(atom::Atom) = Cxx.getSymbol(atom.ptr)

"""
    atomic_num(atom::Atom) -> Int

Return the atomic number of `atom`.
"""
atomic_num(atom::Atom) = Int(Cxx.getAtomicNum(atom.ptr))

"""
    idx(atom::Atom) -> Int

Return the index of `atom` within its molecule.
"""
idx(atom::Atom) = Int(Cxx.getIdx(atom.ptr))

# ---- Bond properties ----

"""
    order(bond::Bond) -> Float64

Return the bond order of `bond` as a double (1.0 for single, 2.0 for double,
1.5 for aromatic, ...).
"""
order(bond::Bond) = Cxx.getBondTypeAsDouble(bond.ptr)

"""
    begin_atom_idx(bond::Bond) -> Int

Return the index of the begin atom of `bond`.
"""
begin_atom_idx(bond::Bond) = Int(Cxx.getBeginAtomIdx(bond.ptr))

"""
    end_atom_idx(bond::Bond) -> Int

Return the index of the end atom of `bond`.
"""
end_atom_idx(bond::Bond) = Int(Cxx.getEndAtomIdx(bond.ptr))

# ---- Molecule properties ----

"""
    num_atoms(mol::RWMol) -> Int

Return the number of explicit atoms in `mol` (heavy atoms plus any explicit
hydrogens; does NOT include implicit hydrogens). For benzene `c1ccccc1` this is
6, not 12. Use `num_heavy_atoms` to count only heavy atoms.
"""
num_atoms(mol::SharedPtrAllocated) = Int(Cxx.getNumAtoms(mol[]))

"""
    num_bonds(mol::RWMol) -> Int

Return the number of bonds in `mol`.
"""
num_bonds(mol::SharedPtrAllocated) = Int(Cxx.getNumBonds(mol[]))

"""
    num_heavy_atoms(mol::RWMol) -> Int

Return the number of heavy atoms in `mol` (excluding implicit hydrogens).
"""
num_heavy_atoms(mol::SharedPtrAllocated) = Int(Cxx.getNumHeavyAtoms(mol[]))
