# test/test_substructure.jl
using Test
using RDKit

@testset "Substructure" begin
    mol = get_mol("c1ccccc1O")
    qmol = get_qmol("ccO")

    @testset "get_substruct_match" begin
        match = get_substruct_match(mol, qmol)
        @test haskey(match, "atoms")
        @test haskey(match, "bonds")
        @test length(match["atoms"]) > 0
    end

    @testset "get_substruct_matches" begin
        matches = get_substruct_matches(mol, qmol)
        @test matches isa Vector
        @test length(matches) > 0
        @test haskey(matches[1], "atoms")
        @test haskey(matches[1], "bonds")
    end
end
