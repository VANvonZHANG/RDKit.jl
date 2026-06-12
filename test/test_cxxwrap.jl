# test_cxxwrap.jl — Tests for CxxWrap backend (RDKit.Cxx module)
# These tests require libjlRDKit.so to be built and JLRDKIT_LIB_PATH to be set.
# They are automatically skipped if the library is not available.
#
# Note: WrapIt/CxxWrap returns smart pointers (SharedPtrAllocated{RWMol})
# for molecules and CxxPtr/ConstCxxPtr for atoms/bonds. Most methods require
# dereferencing with [] to get the underlying CxxRef before dispatch works.

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

        # Round-trip SMILES (mol_to_smiles accepts shared pointer directly)
        smi = Cxx.mol_to_smiles(mol)
        @test smi == "c1ccccc1"

        # Atom count (requires deref [] from SharedPtrAllocated → CxxRef)
        @test Cxx.getNumAtoms(mol[]) == 6
    end

    @testset "Atom Access (mol_get_atoms)" begin
        mol = Cxx.smiles_to_mol("CCO")
        # mol_get_atoms requires deref
        atoms = Cxx.mol_get_atoms(mol[])
        @test length(atoms) == 3

        # Atoms are ConstCxxPtr{Atom}, need [] deref for method calls
        symbols = [Cxx.getSymbol(a[]) for a in atoms]
        @test symbols == ["C", "C", "O"]

        atomic_nums = [Cxx.getAtomicNum(a[]) for a in atoms]
        @test atomic_nums == [6, 6, 8]
    end

    @testset "Bond Access" begin
        mol = Cxx.smiles_to_mol("CCO")
        @test Cxx.getNumBonds(mol[]) == 2

        bond = Cxx.getBondWithIdx(mol[], 0)
        @test bond !== nothing
        # getBondType accepts CxxPtr{Bond} directly (no deref needed)
        @test Cxx.getBondType(bond) !== nothing
    end

    @testset "Molecule Properties" begin
        mol = Cxx.smiles_to_mol("c1ccccc1")
        @test Cxx.getNumHeavyAtoms(mol[]) == 6
        @test Cxx.getNumBonds(mol[]) == 6
    end

    @testset "Molecule Modification (RWMol)" begin
        mol = Cxx.smiles_to_mol("C")
        @test Cxx.getNumAtoms(mol[]) == 1

        # addAtom() without args adds a default atom
        Cxx.addAtom(mol[])
        @test Cxx.getNumAtoms(mol[]) == 2

        # addBond with atom indices (integer-based)
        Cxx.addBond(mol[], 0, 1)
        @test Cxx.getNumBonds(mol[]) == 1
    end

    @testset "Ring Info" begin
        mol = Cxx.smiles_to_mol("c1ccccc1")
        ring_info = Cxx.getRingInfo(mol[])
        @test ring_info !== nothing

        # numAtomRings/numBondRings take an atom/bond index argument
        # (checking if that specific atom/bond is in a ring)
        @test Cxx.numAtomRings(ring_info[], 0) == 1  # atom 0 is in 1 ring
        @test Cxx.numBondRings(ring_info[], 0) == 1  # bond 0 is in 1 ring
    end

    @testset "Sanitization (MolOps)" begin
        mol = Cxx.smiles_to_mol("C1=CC=CC=C1")
        @test mol !== nothing
        # Molecule should be sanitized by default in smiles_to_mol
        smi = Cxx.mol_to_smiles(mol)
        @test smi == "c1ccccc1"
    end
end
