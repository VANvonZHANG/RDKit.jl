using Test
using RDKit

@testset "RDKit.jl" begin
    include("test_io.jl")
    include("test_calculators.jl")
    include("test_drawing.jl")
    include("test_substructure.jl")
end
