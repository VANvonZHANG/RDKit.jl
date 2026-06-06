# src/types.jl
# Layer 2: Core types — Mol and Reaction structs with GC finalizers

"""
    Mol

A mutable struct holding a serialized RDKit molecule as a binary pickle blob.
Memory is automatically freed by Julia's GC when the object goes out of scope.
"""
mutable struct Mol
    pkl::Ref{Cstring}
    pkl_size::Ref{Csize_t}

    function Mol(pkl::Cstring, pkl_size::Ref{Csize_t})
        objref = Ref{Cstring}(pkl)
        x = new(objref, pkl_size)
        finalizer(x -> ccall((:free_ptr, librdkitcffi), Cvoid, (Cstring,), x.pkl[]), x)
        return x
    end
end

"""
    Reaction

A mutable struct holding a serialized RDKit reaction as a binary pickle blob.
Memory is automatically freed by Julia's GC when the object goes out of scope.
"""
mutable struct Reaction
    pkl::Ref{Cstring}
    pkl_size::Ref{Csize_t}

    function Reaction(pkl::Cstring, pkl_size::Ref{Csize_t})
        objref = Ref{Cstring}(pkl)
        x = new(objref, pkl_size)
        finalizer(x -> ccall((:free_ptr, librdkitcffi), Cvoid, (Cstring,), x.pkl[]), x)
        return x
    end
end
