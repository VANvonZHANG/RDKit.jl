# test/test_coordinates.jl
using Test
using RDKit

@testset "Coordinates" begin
    @testset "has_coords" begin
        mol = get_mol("CCO")
        @test has_coords(mol) == 0
    end

    @testset "set_2d_coords" begin
        mol = get_mol("CCO")
        set_2d_coords(mol)
        @test has_coords(mol) != 0
    end

    @testset "set_3d_coords" begin
        mol = get_mol("CCO")
        set_3d_coords(mol)
        @test has_coords(mol) != 0
    end

    @testset "prefer_coordgen" begin
        prefer_coordgen(1)
        mol = get_mol("CCO")
        set_2d_coords(mol)
        @test has_coords(mol) != 0
        prefer_coordgen(0)
    end
end
