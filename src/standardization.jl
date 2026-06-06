# src/standardization.jl
# Layer 3: Molecule standardization functions

"""
    cleanup(mol[, details])

Apply cleanup operations to the molecule (in-place).
"""
function cleanup(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:cleanup, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring),
          mol.pkl, mol.pkl_size, details_json)
end

"""
    normalize(mol[, details])

Normalize the molecule's functional groups (in-place).
"""
function normalize(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:normalize, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring),
          mol.pkl, mol.pkl_size, details_json)
end

"""
    neutralize(mol[, details])

Neutralize charges on the molecule (in-place).
"""
function neutralize(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:neutralize, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring),
          mol.pkl, mol.pkl_size, details_json)
end

"""
    reionize(mol[, details])

Reionize the molecule (in-place).
"""
function reionize(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:reionize, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring),
          mol.pkl, mol.pkl_size, details_json)
end

"""
    canonical_tautomer(mol[, details])

Convert the molecule to its canonical tautomer (in-place).
"""
function canonical_tautomer(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:canonical_tautomer, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring),
          mol.pkl, mol.pkl_size, details_json)
end

"""
    charge_parent(mol[, details])

Get the charge parent of the molecule (in-place).
"""
function charge_parent(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:charge_parent, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring),
          mol.pkl, mol.pkl_size, details_json)
end

"""
    fragment_parent(mol[, details])

Get the fragment parent of the molecule (in-place).
"""
function fragment_parent(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)
    details_json = jsonify_details(details)
    ccall((:fragment_parent, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring),
          mol.pkl, mol.pkl_size, details_json)
end
