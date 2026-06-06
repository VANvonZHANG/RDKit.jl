# test/test_io.jl
using Test
using RDKit

@testset "I/O" begin
    @testset "get_mol from SMILES" begin
        mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")
        @test mol !== nothing
        @test mol isa RDKit.Mol
    end

    @testset "get_mol from SMILES with details" begin
        mol = get_mol("CCO", Dict{String,Any}())
        @test mol !== nothing
    end

    @testset "get_mol invalid" begin
        @test get_mol("xyz_invalid") === nothing
    end

    @testset "get_qmol" begin
        qmol = get_qmol("c1ccccc1")
        @test qmol !== nothing
        @test qmol isa RDKit.Mol
    end

    @testset "get_rxn" begin
        rxn = get_rxn("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
        @test rxn !== nothing
        @test rxn isa RDKit.Reaction
    end

    @testset "SMILES round-trip" begin
        mol = get_mol("CCO")
        smiles = get_smiles(mol)
        @test occursin("CCO", smiles)
    end

    @testset "get_smarts" begin
        mol = get_mol("CCO")
        smarts = get_smarts(mol)
        @test length(smarts) > 0
    end

    @testset "get_cxsmiles" begin
        mol = get_mol("CCO")
        cxsmiles = get_cxsmiles(mol)
        @test length(cxsmiles) > 0
    end

    @testset "get_molblock" begin
        mol = get_mol("CCO")
        mb = get_molblock(mol)
        @test occursin("V2000", mb) || occursin("END", mb)
    end

    @testset "get_v3kmolblock" begin
        mol = get_mol("CCO")
        mb = get_v3kmolblock(mol)
        @test occursin("V3000", mb)
    end

    @testset "get_v2kmolblock" begin
        mol = get_mol("CCO")
        mb = get_v2kmolblock(mol)
        @test occursin("V2000", mb)
    end

    @testset "get_json" begin
        mol = get_mol("CCO")
        j = get_json(mol)
        @test occursin("atoms", j)
    end

    @testset "get_inchi" begin
        mol = get_mol("CCO")
        inchi = get_inchi(mol)
        @test occursin("InChI=", inchi)
    end

    @testset "get_inchi_for_molblock" begin
        mol = get_mol("CCO")
        mb = get_molblock(mol)
        inchi = get_inchi_for_molblock(mb)
        @test occursin("InChI=", inchi)
    end

    @testset "get_inchikey_for_inchi" begin
        inchikey = get_inchikey_for_inchi("InChI=1S/C9H8O4/c1-6(10)13-8-5-3-2-4-7(8)9(11)12/h2-5H,1H3,(H,11,12)")
        @test length(inchikey) > 10
    end

    @testset "get_cxsmarts" begin
        mol = get_mol("CCO")
        cs = get_cxsmarts(mol)
        @test length(cs) > 0
    end

    @testset "get_mol_frags" begin
        mol = get_mol("CC.O")
        frags = get_mol_frags(mol)
        @test length(frags) == 2
    end
end
