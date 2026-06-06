# src/substructure.jl

"""
    get_substruct_match(mol, qmol[, options]) -> Dict{String,Any}

Find the first substructure match. Returns Dict with "atoms" and "bonds" arrays.
"""
function get_substruct_match(mol::Mol, qmol::Mol, options::Union{Dict{String,Any},Nothing}=nothing)::Dict{String,Any}
    options_json = jsonify_details(options)
    val = ccall((:get_substruct_match, librdkitcffi), Cstring,
                (Cstring, Csize_t, Cstring, Csize_t, Cstring),
                mol.pkl[], mol.pkl_size[], qmol.pkl[], qmol.pkl_size[], options_json)
    return JSON.parse(unsafe_string_and_free(val); dicttype=Dict{String,Any})
end

"""
    get_substruct_matches(mol, qmol[, options]) -> Vector{Dict{String,Any}}

Find all substructure matches. Returns a vector of match dicts, each with "atoms" and "bonds" arrays.
"""
function get_substruct_matches(mol::Mol, qmol::Mol, options::Union{Dict{String,Any},Nothing}=nothing)::Vector{Dict{String,Any}}
    options_json = jsonify_details(options)
    val = ccall((:get_substruct_matches, librdkitcffi), Cstring,
                (Cstring, Csize_t, Cstring, Csize_t, Cstring),
                mol.pkl[], mol.pkl_size[], qmol.pkl[], qmol.pkl_size[], options_json)
    result = JSON.parse(unsafe_string_and_free(val); dicttype=Dict{String,Any})
    return Vector{Dict{String,Any}}(result)
end
