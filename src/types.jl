# Julian wrapper types with parent-child GC safety.
#
# Molecules are owned via CxxWrap shared pointers; atom/bond references hold
# a reference to their parent molecule so Julia's GC keeps the molecule alive
# for as long as any of its atoms/bonds are reachable.
#
# WrapIt registers the wrapped C++ types under their fully-qualified names
# (e.g. `RDKit.Cxx.RDKit!RWMol`), which only exist after the C++ module has
# loaded (at `__init__` time). We therefore:
#   * keep the user-facing `RWMol` / `ROMol` names as documentation aliases,
#     binding them to the concrete shared-pointer types in the module
#     `__init__` (see RDKit.jl);
#   * dispatch the Julian API on the statically-known `SharedPtrAllocated`
#     (the unparametrised supertype of every CxxWrap shared pointer);
#   * store the dereferenced atom/bond handle in an `Any` field, since the
#     exact wrapped type (`RDKit!AtomDereferenced`) is not available at
#     parse time.

using CxxWrap
using CxxWrap.StdLib: SharedPtrAllocated

"""
    RWMol

A mutable molecule backed by RDKit's `RWMol`. Memory is managed through a
CxxWrap shared pointer and reclaimed by Julia's GC.

Obtain one with [`smiles_to_mol`](@ref) or [`molblock_to_mol`](@ref).

The concrete type is `SharedPtrAllocated{RDKit.Cxx.RDKit!RWMol}`.
"""
RWMol

"""
    ROMol

A read-only molecule backed by RDKit's `ROMol`. Memory is managed through a
CxxWrap shared pointer and reclaimed by Julia's GC.

The concrete type is `SharedPtrAllocated{RDKit.Cxx.RDKit!ROMol}`.
"""
ROMol

"""
    Atom

A reference to an atom within a molecule. It holds a reference to its parent
molecule for GC safety (the molecule is kept alive as long as any of its
atoms/bonds are reachable).
"""
struct Atom
    ptr::Any          # dereferenced C++ atom handle (a CxxWrap reference type)
    parent::SharedPtrAllocated
end

"""
    Bond

A reference to a bond within a molecule. It holds a reference to its parent
molecule for GC safety (the molecule is kept alive as long as any of its
atoms/bonds are reachable).
"""
struct Bond
    ptr::Any          # dereferenced C++ bond handle (a CxxWrap reference type)
    parent::SharedPtrAllocated
end
