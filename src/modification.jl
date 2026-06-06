# src/modification.jl
# Layer 3: Add/remove hydrogen functions

"""
    add_hs(mol)

Add explicit hydrogens to the molecule (in-place).
"""
function add_hs(mol::Mol)
    ccall((:add_hs, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}), mol.pkl, mol.pkl_size)
end

"""
    remove_all_hs(mol)

Remove all hydrogens from the molecule (in-place).
"""
function remove_all_hs(mol::Mol)
    ccall((:remove_all_hs, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}), mol.pkl, mol.pkl_size)
end

"""
    remove_hs(mol[, details])

Remove hydrogens with configurable options (in-place).
"""
function remove_hs(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:remove_hs, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring), mol.pkl, mol.pkl_size, details_json)
end
