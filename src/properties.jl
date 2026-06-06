# src/properties.jl
# Layer 3: Molecule property CRUD

"""
    has_prop(mol, key) -> Bool

Check if the molecule has a property with the given key.
"""
function has_prop(mol::Mol, key::AbstractString)::Bool
    ccall((:has_prop, librdkitcffi), Cshort,
          (Cstring, Csize_t, Cstring), mol.pkl[], mol.pkl_size[], key) != 0
end

"""
    get_prop(mol, key) -> String

Get the value of a molecule property.
"""
function get_prop(mol::Mol, key::AbstractString)::String
    val = ccall((:get_prop, librdkitcffi), Cstring,
                (Cstring, Csize_t, Cstring), mol.pkl[], mol.pkl_size[], key)
    return unsafe_string_and_free(val)
end

"""
    get_prop_list(mol; include_private=false, include_computed=false) -> Vector{String}

Get the list of property keys on the molecule.
"""
function get_prop_list(mol::Mol; include_private::Bool=false, include_computed::Bool=false)::Vector{String}
    ptr = ccall((:get_prop_list, librdkitcffi), Ptr{Cstring},
                (Cstring, Csize_t, Cshort, Cshort),
                mol.pkl[], mol.pkl_size[], Cshort(include_private), Cshort(include_computed))
    result = String[]
    i = 1
    while true
        p = unsafe_load(ptr, i)
        p == C_NULL && break
        push!(result, unsafe_string(p))
        i += 1
    end
    ccall((:free_ptr, librdkitcffi), Cvoid, (Ptr{Cvoid},), ptr)
    return result
end

"""
    set_prop!(mol, key, value; computed=false)

Set a property on the molecule (in-place).
"""
function set_prop!(mol::Mol, key::AbstractString, value::AbstractString; computed::Bool=false)
    ccall((:set_prop, librdkitcffi), Cvoid,
          (Ref{Cstring}, Ref{Csize_t}, Cstring, Cstring, Cshort),
          mol.pkl, mol.pkl_size, key, value, Cshort(computed))
end

"""
    clear_prop!(mol, key)

Remove a property from the molecule (in-place).
"""
function clear_prop!(mol::Mol, key::AbstractString)
    ccall((:clear_prop, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring), mol.pkl, mol.pkl_size, key)
end

"""
    keep_props(mol, keys)

Keep only the specified properties on the molecule, removing all others (in-place).
"""
function keep_props(mol::Mol, keys::Vector{String})
    details_json = JSON.json(Dict{String,Any}("props" => keys))
    ccall((:keep_props, librdkitcffi), Cvoid,
          (Ref{Cstring}, Ref{Csize_t}, Cstring), mol.pkl, mol.pkl_size, details_json)
end
