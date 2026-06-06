# test/test_modification.jl
using Test
using RDKit

@testset "Modification" begin
    @testset "add_hs" begin
        mol = get_mol("CCO")
        smiles_before = get_smiles(mol)
        add_hs(mol)
        smiles_after = get_smiles(mol)
        @test smiles_after !== nothing
    end

    @testset "remove_all_hs" begin
        mol = get_mol("CCO")
        add_hs(mol)
        remove_all_hs(mol)
        smiles = get_smiles(mol)
        @test occursin("CCO", smiles)
    end

    @testset "remove_hs" begin
        mol = get_mol("CCO")
        add_hs(mol)
        remove_hs(mol)
        @test get_smiles(mol) !== nothing
    end
end
