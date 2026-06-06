# src/png.jl
# Layer 3: PNG metadata embedding

"""
    add_mol_to_png_blob(png_data, mol[, details]) -> Vector{UInt8}

Embed molecule data into a PNG image. Returns the modified PNG blob.
"""
function add_mol_to_png_blob(png_data::Vector{UInt8}, mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)::Vector{UInt8}
    details_json = jsonify_details(details)
    # CFFI signature: add_mol_to_png_blob(Ref{Cstring}, Ref{Csize_t}, Cstring, Csize_t, Cstring) -> Cshort
    # The C side may free() and reallocate the png_blob, so we must provide a C-owned copy.
    n = length(png_data)
    c_ptr = Libc.malloc(n)
    unsafe_copyto!(Ptr{UInt8}(c_ptr), pointer(png_data), n)
    png_ptr = Ref{Cstring}(reinterpret(Cstring, c_ptr))
    png_size = Ref{Csize_t}(n)
    ccall((:add_mol_to_png_blob, librdkitcffi), Cshort,
          (Ref{Cstring}, Ref{Csize_t}, Cstring, Csize_t, Cstring),
          png_ptr, png_size, mol.pkl[], mol.pkl_size[], details_json)
    # Read back the modified data from the (possibly reallocated) pointer
    result = unsafe_wrap(Vector{UInt8}, reinterpret(Ptr{UInt8}, png_ptr[]), png_size[])
    # Make a Julia-owned copy so we can free the C memory
    copy = Vector{UInt8}(result)
    # Free the C-allocated buffer
    ccall((:free_ptr, librdkitcffi), Cvoid, (Cstring,), png_ptr[])
    return copy
end

"""
    get_mol_from_png_blob(png_data[, details]) -> Union{Mol,Nothing}

Extract a molecule from a PNG image that contains embedded RDKit data.
"""
function get_mol_from_png_blob(png_data::Vector{UInt8}, details::Union{Dict{String,Any},Nothing}=nothing)::Union{Mol,Nothing}
    details_json = jsonify_details(details)
    # CFFI signature: get_mol_from_png_blob(Cstring, Csize_t, Ref{Cstring}, Ref{Csize_t}, Cstring) -> Cshort
    pkl_ptr = Ref{Cstring}(C_NULL)
    pkl_size = Ref{Csize_t}(0)
    ret = ccall((:get_mol_from_png_blob, librdkitcffi), Cshort,
                (Cstring, Csize_t, Ref{Cstring}, Ref{Csize_t}, Cstring),
                reinterpret(Cstring, pointer(png_data)), length(png_data), pkl_ptr, pkl_size, details_json)
    ret == 0 && return nothing
    pkl_ptr[] == C_NULL && return nothing
    return Mol(pkl_ptr[], pkl_size)
end

"""
    get_mols_from_png_blob(png_data[, details]) -> Vector{Mol}

Extract all molecules from a PNG image.
"""
function get_mols_from_png_blob(png_data::Vector{UInt8}, details::Union{Dict{String,Any},Nothing}=nothing)::Vector{Mol}
    details_json = jsonify_details(details)
    # CFFI signature: get_mols_from_png_blob(Cstring, Csize_t, Ref{Ptr{Cstring}}, Ref{Ptr{Csize_t}}, Cstring) -> Cshort
    pkl_array = Ref{Ptr{Cstring}}(C_NULL)
    pkl_sz_array = Ref{Ptr{Csize_t}}(C_NULL)
    ret = ccall((:get_mols_from_png_blob, librdkitcffi), Cshort,
                (Cstring, Csize_t, Ref{Ptr{Cstring}}, Ref{Ptr{Csize_t}}, Cstring),
                reinterpret(Cstring, pointer(png_data)), length(png_data), pkl_array, pkl_sz_array, details_json)
    result = Mol[]
    if ret == 0 || pkl_array[] == C_NULL
        return result
    end
    # Read molecules until we hit NULL
    i = 1
    while true
        p = unsafe_load(pkl_array[], i)
        p == C_NULL && break
        sz = unsafe_load(pkl_sz_array[], i)
        push!(result, Mol(p, Ref(sz)))
        i += 1
    end
    # Free the array containers (individual pickles now owned by Mol objects)
    free_mol_array(pkl_array, pkl_sz_array)
    return result
end

"""
    free_mol_array(arr, sizes)

Free a C-allocated array of molecule pickles.
"""
function free_mol_array(arr::Ref{Ptr{Cstring}}, sizes::Ref{Ptr{Csize_t}})
    ccall((:free_mol_array, librdkitcffi), Cvoid,
          (Ref{Ptr{Cstring}}, Ref{Ptr{Csize_t}}), arr, sizes)
end
