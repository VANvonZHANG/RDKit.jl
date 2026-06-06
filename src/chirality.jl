# src/chirality.jl
# Layer 3: Chirality settings

"""
    use_legacy_stereo_perception(value)

Set whether to use legacy stereo perception (1=yes, 0=no).
"""
function use_legacy_stereo_perception(value::Integer)
    ccall((:use_legacy_stereo_perception, librdkitcffi), Cshort, (Cshort,), Cshort(value))
end

"""
    allow_non_tetrahedral_chirality(value)

Set whether to allow non-tetrahedral chirality (1=yes, 0=no).
"""
function allow_non_tetrahedral_chirality(value::Integer)
    ccall((:allow_non_tetrahedral_chirality, librdkitcffi), Cshort, (Cshort,), Cshort(value))
end
