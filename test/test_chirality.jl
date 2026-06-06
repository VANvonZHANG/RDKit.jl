using Test
using RDKit

@testset "Chirality" begin
    @testset "use_legacy_stereo_perception" begin
        use_legacy_stereo_perception(0)
        use_legacy_stereo_perception(1)
        use_legacy_stereo_perception(0)
        @test true
    end

    @testset "allow_non_tetrahedral_chirality" begin
        allow_non_tetrahedral_chirality(1)
        allow_non_tetrahedral_chirality(0)
        @test true
    end
end
