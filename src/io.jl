# src/io.jl

# --- Constructors (special: return Mol/Reaction or nothing) ---

"""
    get_mol(mol_string[, details]) -> Union{Mol,Nothing}

Parse a molecule from SMILES, SMARTS, or molblock (v2000/v3000).
Returns `nothing` if parsing fails.
"""
function get_mol(mol_string::AbstractString, details::Union{Dict{String,Any},Nothing}=nothing)::Union{Mol,Nothing}
    details_json = jsonify_details(details)
    pkl_size = Ref{Csize_t}(0)
    val = ccall((:get_mol, librdkitcffi), Cstring,
                (Cstring, Ref{Csize_t}, Cstring),
                mol_string, pkl_size, details_json)
    val == C_NULL && return nothing
    return Mol(val, pkl_size)
end

"""
    get_qmol(mol_string[, details]) -> Union{Mol,Nothing}

Parse a query molecule for substructure search.
"""
function get_qmol(mol_string::AbstractString, details::Union{Dict{String,Any},Nothing}=nothing)::Union{Mol,Nothing}
    details_json = jsonify_details(details)
    pkl_size = Ref{Csize_t}(0)
    val = ccall((:get_qmol, librdkitcffi), Cstring,
                (Cstring, Ref{Csize_t}, Cstring),
                mol_string, pkl_size, details_json)
    val == C_NULL && return nothing
    return Mol(val, pkl_size)
end

"""
    get_rxn(rxn_string[, details]) -> Union{Reaction,Nothing}

Parse a reaction from SMARTS.
"""
function get_rxn(rxn_string::AbstractString, details::Union{Dict{String,Any},Nothing}=nothing)::Union{Reaction,Nothing}
    details_json = jsonify_details(details)
    pkl_size = Ref{Csize_t}(0)
    val = ccall((:get_rxn, librdkitcffi), Cstring,
                (Cstring, Ref{Csize_t}, Cstring),
                rxn_string, pkl_size, details_json)
    val == C_NULL && return nothing
    return Reaction(val, pkl_size)
end

# --- Read-only string queries (use @ccall_string macro) ---

get_smiles(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_smiles, mol, details)

get_smarts(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_smarts, mol, details)

get_cxsmiles(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_cxsmiles, mol, details)

get_cxsmarts(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_cxsmarts, mol, details)

get_molblock(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_molblock, mol, details)

get_v3kmolblock(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_v3kmolblock, mol, details)

get_v2kmolblock(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_v2kmolblock, mol, details)

get_json(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_json, mol, details)

get_inchi(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing) =
    @ccall_string(:get_inchi, mol, details)

# --- Standalone InChI functions (no Mol object needed) ---

"""
    get_inchi_for_molblock(molblock[, details]) -> String

Compute InChI directly from a molblock string.
"""
function get_inchi_for_molblock(molblock::AbstractString, details::Union{Dict{String,Any},Nothing}=nothing)::String
    details_json = jsonify_details(details)
    val = ccall((:get_inchi_for_molblock, librdkitcffi), Cstring,
                (Cstring, Cstring), molblock, details_json)
    return unsafe_string_and_free(val)
end

"""
    get_inchikey_for_inchi(inchi) -> String

Compute InChIKey from an InChI string.
"""
function get_inchikey_for_inchi(inchi::AbstractString)::String
    val = ccall((:get_inchikey_for_inchi, librdkitcffi), Cstring, (Cstring,), inchi)
    return unsafe_string_and_free(val)
end

# --- Molecule fragments (special return type) ---

"""
    get_mol_frags(mol[, details]) -> Vector{Mol}

Split a molecule into its disconnected fragments.
"""
function get_mol_frags(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)::Vector{Mol}
    details_json = jsonify_details(details)
    frags_pkl_sz_array = Ref{Ptr{Csize_t}}(C_NULL)
    num_frags = Ref{Csize_t}(0)
    mappings_json = Ref{Cstring}(C_NULL)

    frags_array = ccall((:get_mol_frags, librdkitcffi), Ptr{Cstring},
                         (Cstring, Csize_t, Ref{Ptr{Csize_t}}, Ref{Csize_t}, Cstring, Ref{Cstring}),
                         mol.pkl[], mol.pkl_size[], frags_pkl_sz_array, num_frags, details_json, mappings_json)

    result = Mol[]
    n = num_frags[]
    if n > 0
        sz_ptr = frags_pkl_sz_array[]
        for i in 1:n
            frag_pkl = unsafe_load(frags_array, i)
            frag_sz = unsafe_load(sz_ptr, i)
            if frag_pkl != C_NULL
                push!(result, Mol(frag_pkl, Ref(frag_sz)))
            end
        end
    end

    # Free the mappings_json string if allocated
    if mappings_json[] != C_NULL
        ccall((:free_ptr, librdkitcffi), Cvoid, (Cstring,), mappings_json[])
    end

    # Free the array containers (frags_array and frags_pkl_sz_array)
    # Individual fragment pickles are now owned by Mol objects with GC finalizers
    if frags_array != C_NULL
        ccall((:free_ptr, librdkitcffi), Cvoid, (Ptr{Cvoid},), frags_array)
    end
    if frags_pkl_sz_array[] != C_NULL
        ccall((:free_ptr, librdkitcffi), Cvoid, (Ptr{Cvoid},), frags_pkl_sz_array[])
    end

    return result
end
