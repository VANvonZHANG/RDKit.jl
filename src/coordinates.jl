# src/coordinates.jl
# Layer 3: 2D/3D coordinate generation

"""
    prefer_coordgen(val)

Set whether to use CoordgenLibs for 2D coordinate generation (1=yes, 0=no).
"""
function prefer_coordgen(val::Integer)
    ccall((:prefer_coordgen, librdkitcffi), Cvoid, (Cshort,), Cshort(val))
end

"""
    has_coords(mol) -> Int

Check if the molecule has coordinates. Returns 0 (none), 1 (2D), or 2 (3D).
"""
function has_coords(mol::Mol)::Int
    ccall((:has_coords, librdkitcffi), Cshort, (Cstring, Csize_t), mol.pkl[], mol.pkl_size[])
end

"""
    set_2d_coords(mol)

Generate 2D coordinates for the molecule (in-place).
"""
function set_2d_coords(mol::Mol)
    ccall((:set_2d_coords, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}), mol.pkl, mol.pkl_size)
end

"""
    set_3d_coords(mol[, details])

Generate 3D coordinates for the molecule (in-place).
"""
function set_3d_coords(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:set_3d_coords, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring),
          mol.pkl, mol.pkl_size, details_json)
end

"""
    set_2d_coords_aligned(mol, template_mol[, details])

Generate 2D coordinates aligned to a template molecule (in-place).
"""
function set_2d_coords_aligned(mol::Mol, template_mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:set_2d_coords_aligned, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring, Csize_t, Cstring, Ref{Cstring}),
          mol.pkl, mol.pkl_size, template_mol.pkl[], template_mol.pkl_size[], details_json, C_NULL)
end
