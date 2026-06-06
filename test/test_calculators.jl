# test/test_calculators.jl
using Test
using RDKit

@testset "Calculators" begin
    mol = get_mol("CC(=O)Oc1ccccc1C(=O)O")

    @testset "Morgan fingerprint" begin
        fp = get_morgan_fp(mol)
        @test isa(fp, String) && length(fp) > 0

        fp_bytes = get_morgan_fp_as_bytes(mol)
        @test fp_bytes isa Vector{UInt8}
        @test length(fp_bytes) > 0

        fp_512 = get_morgan_fp(mol, Dict{String,Any}("nBits" => 512, "radius" => 2))
        @test length(fp_512) > 0
    end

    @testset "RDKit fingerprint" begin
        fp = get_rdkit_fp(mol)
        @test isa(fp, String) && length(fp) > 0

        fp_bytes = get_rdkit_fp_as_bytes(mol)
        @test fp_bytes isa Vector{UInt8}
    end

    @testset "Pattern fingerprint" begin
        fp = get_pattern_fp(mol)
        @test isa(fp, String) && length(fp) > 0

        fp_bytes = get_pattern_fp_as_bytes(mol)
        @test fp_bytes isa Vector{UInt8}
    end

    @testset "Atom pair fingerprint" begin
        fp = get_atom_pair_fp(mol)
        @test isa(fp, String) && length(fp) > 0

        fp_bytes = get_atom_pair_fp_as_bytes(mol)
        @test fp_bytes isa Vector{UInt8}
    end

    @testset "Topological torsion fingerprint" begin
        fp = get_topological_torsion_fp(mol)
        @test isa(fp, String) && length(fp) > 0

        fp_bytes = get_topological_torsion_fp_as_bytes(mol)
        @test fp_bytes isa Vector{UInt8}
    end

    @testset "MACCS fingerprint" begin
        fp = get_maccs_fp(mol)
        @test isa(fp, String) && length(fp) > 0

        fp_bytes = get_maccs_fp_as_bytes(mol)
        @test fp_bytes isa Vector{UInt8}
    end

    @testset "Descriptors" begin
        desc = get_descriptors(mol)
        @test desc isa Dict{String,Any}
        @test haskey(desc, "exactmw")
        @test desc["exactmw"] > 0
    end
end
