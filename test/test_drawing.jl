# test/test_drawing.jl
using Test
using RDKit

@testset "Drawing" begin
    mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")

    @testset "get_svg" begin
        svg = get_svg(mol)
        @test occursin("<svg", svg)
        @test occursin("</svg>", svg)
    end

    @testset "get_svg with details" begin
        svg = get_svg(mol, Dict{String,Any}("width" => 300, "height" => 300))
        @test occursin("<svg", svg)
    end

    @testset "get_svg with substruct match" begin
        qmol = get_qmol("ccO")
        match = get_substruct_match(mol, qmol)
        svg = get_svg(mol, Dict{String,Any}("atoms" => match["atoms"], "bonds" => match["bonds"]))
        @test occursin("<svg", svg)
    end

    @testset "get_rxn_svg" begin
        rxn = get_rxn("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
        svg = get_rxn_svg(rxn)
        @test occursin("<svg", svg)
    end
end
