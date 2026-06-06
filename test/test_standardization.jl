# test/test_standardization.jl
using Test
using RDKit

@testset "Standardization" begin
    @testset "cleanup" begin
        mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")
        cleanup(mol)
        @test get_smiles(mol) !== nothing
    end

    @testset "normalize" begin
        mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")
        normalize(mol)
        @test get_smiles(mol) !== nothing
    end

    @testset "reionize" begin
        mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")
        reionize(mol)
        @test get_smiles(mol) !== nothing
    end

    @testset "neutralize" begin
        mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")
        neutralize(mol)
        @test get_smiles(mol) !== nothing
    end

    @testset "canonical_tautomer" begin
        mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")
        canonical_tautomer(mol)
        @test get_smiles(mol) !== nothing
    end

    @testset "charge_parent" begin
        mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")
        charge_parent(mol)
        @test get_smiles(mol) !== nothing
    end

    @testset "fragment_parent" begin
        mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")
        fragment_parent(mol)
        @test get_smiles(mol) !== nothing
    end
end
