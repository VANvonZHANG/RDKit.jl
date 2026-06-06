# src/calculators.jl

# --- String-form fingerprints (return hex/binary string) ---

get_morgan_fp(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_morgan_fp, mol, details)

get_rdkit_fp(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_rdkit_fp, mol, details)

get_pattern_fp(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_pattern_fp, mol, details)

get_atom_pair_fp(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_atom_pair_fp, mol, details)

get_topological_torsion_fp(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_topological_torsion_fp, mol, details)

# MACCS has no details parameter — call directly
"""
    get_maccs_fp(mol) -> String

Compute the MACCS keys fingerprint as a hex/binary string.
"""
function get_maccs_fp(mol::Mol)::String
    val = ccall((:get_maccs_fp, librdkitcffi), Cstring,
                (Cstring, Csize_t),
                mol.pkl[], mol.pkl_size[])
    return unsafe_string_and_free(val)
end

# --- Byte-form fingerprints (return Vector{UInt8}) ---

get_morgan_fp_as_bytes(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_bytes(:get_morgan_fp_as_bytes, mol, details)

get_rdkit_fp_as_bytes(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_bytes(:get_rdkit_fp_as_bytes, mol, details)

get_pattern_fp_as_bytes(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_bytes(:get_pattern_fp_as_bytes, mol, details)

get_atom_pair_fp_as_bytes(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_bytes(:get_atom_pair_fp_as_bytes, mol, details)

get_topological_torsion_fp_as_bytes(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_bytes(:get_topological_torsion_fp_as_bytes, mol, details)

# MACCS as bytes — no details parameter
"""
    get_maccs_fp_as_bytes(mol) -> Vector{UInt8}

Compute the MACCS keys fingerprint as a raw byte vector.
"""
function get_maccs_fp_as_bytes(mol::Mol)::Vector{UInt8}
    n_bytes = Ref{Csize_t}(0)
    val = ccall((:get_maccs_fp_as_bytes, librdkitcffi), Cstring,
                (Cstring, Csize_t, Ref{Csize_t}),
                mol.pkl[], mol.pkl_size[], n_bytes)
    return Vector{UInt8}(unsafe_string_and_free(val, n_bytes))
end

# --- Descriptors ---

"""
    get_descriptors(mol) -> Dict{String,Any}

Compute physicochemical descriptors (molecular weight, logP, TPSA, etc.).
"""
function get_descriptors(mol::Mol)::Dict{String,Any}
    val = ccall((:get_descriptors, librdkitcffi), Cstring,
                (Cstring, Csize_t),
                mol.pkl[], mol.pkl_size[])
    return JSON.parse(unsafe_string_and_free(val); dicttype=Dict{String,Any})
end
