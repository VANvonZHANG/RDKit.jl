using Test
using RDKit

@testset "RDKit.jl" begin
    include("test_io.jl")
    include("test_calculators.jl")
    include("test_drawing.jl")
    include("test_substructure.jl")
    include("test_standardization.jl")
    include("test_modification.jl")
    include("test_coordinates.jl")
    include("test_properties.jl")
    include("test_png.jl")
    include("test_chirality.jl")
    include("test_logging.jl")
end
