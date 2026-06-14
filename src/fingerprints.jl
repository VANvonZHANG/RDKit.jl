# Fingerprint calculations.
#
# The shims take the SharedPtrAllocated<RWMol> directly (CxxWrap converts to
# `const std::shared_ptr<RWMol>&`) and return a `std::vector<uint8_t>`, which
# arrives as a `Vector{UInt8}` of raw packed bytes (nbits/8 bytes).

"""
    morgan_fingerprint(mol::RWMol; radius::Integer=2, nbits::Integer=2048) -> Vector{UInt8}

Compute the Morgan (ECP-like) fingerprint of `mol` as a packed byte vector
(`nbits ÷ 8` bytes).
"""
function morgan_fingerprint(mol::SharedPtrAllocated; radius::Integer=2, nbits::Integer=2048)
    return Cxx.calc_morgan_fp(mol, UInt32(radius), UInt32(nbits))
end

"""
    rdkit_fingerprint(mol::RWMol; min_path::Integer=1, max_path::Integer=7) -> Vector{UInt8}

Compute the RDKit path-based fingerprint of `mol` as a packed byte vector.
"""
function rdkit_fingerprint(mol::SharedPtrAllocated; min_path::Integer=1, max_path::Integer=7)
    return Cxx.calc_rdkit_fp(mol, UInt32(min_path), UInt32(max_path))
end
