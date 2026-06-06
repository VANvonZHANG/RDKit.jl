# src/api.jl
# Layer 2: API macros and helper functions

"""
    jsonify_details(details) -> String

Convert a Dict to JSON string, or return "" for nothing.
"""
function jsonify_details(details::Union{Dict{String,Any},Nothing})::String
    if isnothing(details)
        return ""
    end
    return JSON.json(details)
end

"""
    unsafe_string_and_free(cstring[, length]) -> String

Convert a Cstring to Julia String and free the C memory.
If `length` is provided, use it for the string length.
"""
function unsafe_string_and_free(cstring::Cstring, length::Union{Ref{Csize_t},Nothing}=nothing)::String
    if isnothing(length)
        str = unsafe_string(cstring)
    else
        str = unsafe_string(pointer(cstring), length[])
    end
    ccall((:free_ptr, librdkitcffi), Cvoid, (Cstring,), cstring)
    return str
end

"""
    @ccall_string(func_name, mol, details)

Macro for read-only query functions that return a String.
Pattern: jsonify_details → ccall → unsafe_string_and_free
"""
macro ccall_string(func_name, mol, details)
    quote
        local details_json = jsonify_details($(esc(details)))
        local val = ccall(($(esc(func_name)), librdkitcffi), Cstring,
                          (Cstring, Csize_t, Cstring),
                          $(esc(mol)).pkl[], $(esc(mol)).pkl_size[], details_json)
        unsafe_string_and_free(val)
    end
end

"""
    @ccall_bytes(func_name, mol, details)

Macro for fingerprint functions that return Vector{UInt8}.
Pattern: jsonify_details → ccall with n_bytes → unsafe_string_and_free → Vector{UInt8}
"""
macro ccall_bytes(func_name, mol, details)
    quote
        local details_json = jsonify_details($(esc(details)))
        local n_bytes = Ref{Csize_t}(0)
        local val = ccall(($(esc(func_name)), librdkitcffi), Cstring,
                          (Cstring, Csize_t, Ref{Csize_t}, Cstring),
                          $(esc(mol)).pkl[], $(esc(mol)).pkl_size[], n_bytes, details_json)
        Vector{UInt8}(unsafe_string_and_free(val, n_bytes))
    end
end

"""
    @ccall_mutate!(func_name, mol, details)

Macro for functions that mutate the molecule in-place.
Pattern: jsonify_details → ccall with Ref params → no return value
"""
macro ccall_mutate!(func_name, mol, details)
    quote
        local details_json = jsonify_details($(esc(details)))
        ccall(($(esc(func_name)), librdkitcffi), Cvoid,
              (Ref{Cstring}, Ref{Csize_t}, Cstring),
              $(esc(mol)).pkl, $(esc(mol)).pkl_size, details_json)
    end
end
