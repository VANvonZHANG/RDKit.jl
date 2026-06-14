# GC safety: atom/bond wrappers hold a reference to their parent molecule
# (src/types.jl), so the molecule stays alive as long as any of its
# atoms/bonds are reachable. Dropping the molecule reference and forcing GC
# must NOT invalidate the atom wrappers.
@testset "GC safety: parent-child lifecycle" begin
    mol = smiles_to_mol("c1ccccc1")
    atom_list = atoms(mol)

    mol = nothing  # drop parent reference
    GC.gc()

    # Atom survives — the wrapper holds the parent ref.
    @test symbol(atom_list[1]) == "C"
    @test atomic_num(atom_list[1]) == 6

    atom_list = nothing
    GC.gc()

    # Multiple GC cycles interleaved with molecule creation: no crash = no
    # memory corruption in the CxxWrap shared-pointer ownership.
    for i in 1:100
        m = smiles_to_mol("c1ccccc1")
        a = atoms(m)
        GC.gc()
        @test length(a) == 6
    end
    @test true
end
