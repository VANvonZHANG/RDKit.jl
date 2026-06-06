using Test
using RDKit

@testset "Properties" begin
    mol = get_mol("CCO")

    @testset "set_prop / get_prop / has_prop" begin
        set_prop!(mol, "name", "ethanol")
        @test has_prop(mol, "name") == true
        @test get_prop(mol, "name") == "ethanol"
        @test has_prop(mol, "nonexistent") == false
    end

    @testset "get_prop_list" begin
        set_prop!(mol, "name", "ethanol")
        props = get_prop_list(mol)
        @test "name" in props
    end

    @testset "clear_prop" begin
        set_prop!(mol, "temp", "value")
        clear_prop!(mol, "temp")
        @test has_prop(mol, "temp") == false
    end

    @testset "keep_props" begin
        set_prop!(mol, "a", "1")
        set_prop!(mol, "b", "2")
        keep_props(mol, ["a"])
        @test has_prop(mol, "a") == true
    end
end
