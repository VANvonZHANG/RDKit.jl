# Atom/Bond traversal: the Julian `atoms`/`bonds` accessors return GC-safe
# wrappers (src/atoms.jl, src/types.jl) that hold a reference to the parent
# molecule. Property accessors (`symbol`, `idx`, ...) live in src/properties.jl.
#
# Verified behavior:
#   * RDKit atom indexing is 0-based, so `idx(atom_list[1]) == 0`.
#   * Benzene bonds are aromatic -> `order(bond) == 1.5`.
#   * `smiles_to_mol("O")` yields a molecule with only the heavy oxygen atom
#     (implicit hydrogens are not counted by `num_atoms`).
@testset "Atom/Bond traversal" begin
    mol = smiles_to_mol("c1ccccc1")

    atom_list = atoms(mol)
    @test length(atom_list) == 6
    @test symbol(atom_list[1]) == "C"
    @test atomic_num(atom_list[1]) == 6
    @test idx(atom_list[1]) == 0

    bond_list = bonds(mol)
    @test length(bond_list) == 6
    # Aromatic bond -> 1.5; ring bonds link consecutive atoms (0-indexed).
    @test order(bond_list[1]) == 1.5
    @test begin_atom_idx(bond_list[1]) == 0
    @test end_atom_idx(bond_list[1]) == 1

    water = smiles_to_mol("O")
    @test num_atoms(water) == 1  # only the heavy atom
end
