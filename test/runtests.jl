using Test
using RDKit

@testset "RDKit.jl CxxWrap-only" begin
    include("test_io.jl")
    include("test_atoms.jl")
    include("test_gc_safety.jl")
    include("test_fingerprints.jl")
    include("test_drawing.jl")
    include("test_exceptions.jl")
end
