# Exception handling: invalid input must surface as a Julia exception (a C++
# exception propagated through CxxWrap), NOT a crash/segfault.
#
# Verified behavior of this build:
#   * `smiles_to_mol` / `molblock_to_mol` themselves do NOT throw on garbage
#     input — the C++ parser constructs a molecule object but records parse
#     errors that surface as an ErrorException when the molecule is QUERIED
#     (e.g. via `num_atoms`). The tests below trigger the exception through
#     access, which is where it reliably occurs.
#   * An EMPTY SMILES `""` is valid input and yields a 0-atom molecule (no
#     throw) — tested separately as a documented edge case.
@testset "Exception handling" begin
    # Invalid SMILES: parser returns a broken molecule; querying it throws.
    broken_mol = smiles_to_mol("not_valid_smiles_xyz!!!")
    @test_throws Exception num_atoms(broken_mol)

    # Invalid MolBlock: same pattern.
    broken_mol2 = molblock_to_mol("not a molblock")
    @test_throws Exception num_atoms(broken_mol2)

    # Empty SMILES is valid -> a well-formed 0-atom molecule, no exception.
    empty_mol = smiles_to_mol("")
    @test num_atoms(empty_mol) == 0

    # Julia process is still alive and functional after the exceptions.
    mol = smiles_to_mol("c1ccccc1")
    @test num_atoms(mol) == 6
    @test symbol(atoms(mol)[1]) == "C"
end
