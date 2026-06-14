# Molecule I/O: SMILES <-> MolBlock round-trip, atom/bond counts, heavy atoms.
#
# The Julian API (`smiles_to_mol`, `to_smiles`, ...) is defined in
# src/io.jl and dispatches on the CxxWrap SharedPtrAllocated shared pointer.
@testset "Molecule I/O" begin
    mol = smiles_to_mol("c1ccccc1")
    @test mol !== nothing
    @test num_atoms(mol) == 6
    @test num_bonds(mol) == 6

    smi = to_smiles(mol)
    @test smi == "c1ccccc1"

    block = to_molblock(mol)
    @test occursin("V2000", block)

    mol2 = molblock_to_mol(block)
    @test mol2 !== nothing
    @test num_atoms(mol2) == 6

    # Caffeine: 14 heavy atoms, no explicit hydrogens in the SMILES.
    caffeine = smiles_to_mol("CN1C=NC2=C1C(=O)N(C(=O)N2C)C")
    @test num_atoms(caffeine) == 14
    @test num_heavy_atoms(caffeine) == 14
    @test num_bonds(caffeine) == 15
end
