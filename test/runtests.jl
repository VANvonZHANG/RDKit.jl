using Test
using RDKit

@testset "RDKit.jl" begin
    include("test_io.jl")
    include("test_calculators.jl")
end
