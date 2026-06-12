# test_cxxwrap.jl — Tests for CxxWrap backend (RDKit.Cxx module)
# These tests require libjlRDKit.so to be built and JLRDKIT_LIB_PATH to be set.
# They are automatically skipped if the library is not available.

using Test

@testset "CxxWrap Backend" begin
    # Skip entire testset if CxxWrap backend is not loaded
    if !RDKit._cxx_available[]
        @warn "Skipping CxxWrap tests — JLRDKIT_LIB_PATH not set or library not found"
        return
    end

    Cxx = RDKit.Cxx

    @testset "SMILES I/O (smiles_to_mol / mol_to_smiles)" begin
        mol = Cxx.smiles_to_mol("c1ccccc1")
        @test mol !== nothing

        # Round-trip SMILES
        smi = Cxx.mol_to_smiles(mol)
        @test smi == "c1ccccc1"

        # Atom count
        @test Cxx.getNumAtoms(mol) == 6
    end

    @testset "Atom Access (mol_get_atoms)" begin
        mol = Cxx.smiles_to_mol("CCO")
        atoms = Cxx.mol_get_atoms(mol)
        @test length(atoms) == 3

        # Verify atom symbols
        symbols = [Cxx.getSymbol(a) for a in atoms]
        @test symbols == ["C", "C", "O"]

        # Verify atomic numbers
        atomic_nums = [Cxx.getAtomicNum(a) for a in atoms]
        @test atomic_nums == [6, 6, 8]
    end

    @testset "Bond Access" begin
        mol = Cxx.smiles_to_mol("CCO")
        @test Cxx.getNumBonds(mol) == 2

        bond = Cxx.getBondWithIdx(mol, 0)
        @test bond !== nothing
        @test Cxx.getBondType(bond) !== nothing
    end

    @testset "Molecule Properties" begin
        mol = Cxx.smiles_to_mol("c1ccccc1")
        @test Cxx.getNumHeavyAtoms(mol) == 6

        # Set and get a property
        Cxx.setName(mol, "benzene")
        @test Cxx.getName(mol) == "benzene"
    end

    @testset "Molecule Modification (RWMol)" begin
        mol = Cxx.smiles_to_mol("C")
        @test Cxx.getNumAtoms(mol) == 1

        # Add an atom (oxygen)
        new_atom = Cxx.Atom(8)
        Cxx.addAtom(mol, new_atom)
        @test Cxx.getNumAtoms(mol) == 2

        # Add a single bond between atom 0 and atom 1
        # getBondType on an existing single bond returns the BondType enum
        ref_mol = Cxx.smiles_to_mol("CC")
        bond_type = Cxx.getBondType(Cxx.getBondWithIdx(ref_mol, 0))
        Cxx.addBond(mol, 0, 1, bond_type)
        @test Cxx.getNumBonds(mol) == 1
    end

    @testset "Ring Info" begin
        mol = Cxx.smiles_to_mol("c1ccccc1")
        ring_info = Cxx.getRingInfo(mol)
        @test ring_info !== nothing
        @test Cxx.numAtomRings(ring_info) == 1
        @test Cxx.numBondRings(ring_info) == 1
    end

    @testset "Sanitization (MolOps)" begin
        mol = Cxx.smiles_to_mol("C1=CC=CC=C1")
        @test mol !== nothing
        # Molecule should be sanitized by default in smiles_to_mol
        smi = Cxx.mol_to_smiles(mol)
        @test smi == "c1ccccc1"
    end
end
