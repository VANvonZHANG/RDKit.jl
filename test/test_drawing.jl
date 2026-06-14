# Drawing: `to_svg` (src/drawing.jl) returns an XML+SVG depiction string.
#
# Verified behavior: RDKit draws aromatic rings WITHOUT explicit atom labels,
# so a literal "C" does not appear in the benzene SVG. Only the structural
# `<svg>`/`</svg>` markers are asserted.
@testset "Drawing" begin
    mol = smiles_to_mol("c1ccccc1")

    svg = to_svg(mol)
    @test occursin("<svg", svg)
    @test occursin("</svg>", svg)

    svg2 = to_svg(mol; width=500, height=500)
    @test occursin("<svg", svg2)
    @test occursin("</svg>", svg2)

    # Custom dimensions flow through to the renderer (not silently dropped).
    @test length(svg2) != length(svg)
end
