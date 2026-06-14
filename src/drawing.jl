# Molecule depiction.
#
# The `mol_to_svg` shim takes the SharedPtrAllocated<RWMol> directly (CxxWrap
# converts to `const std::shared_ptr<RWMol>&`) and returns a CxxWrap
# `StdStringAllocated`; we convert it to a plain Julia `String`.

"""
    to_svg(mol::RWMol; width::Integer=300, height::Integer=300) -> String

Generate an SVG (wrapped in a small XML prologue) depiction of `mol` with the
requested pixel dimensions.
"""
function to_svg(mol::SharedPtrAllocated; width::Integer=300, height::Integer=300)
    return String(Cxx.mol_to_svg(mol, Int(width), Int(height)))
end
