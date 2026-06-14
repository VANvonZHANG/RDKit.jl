# Fingerprints: the Julian accessors (src/fingerprints.jl) return the raw
# packed byte vector (nbits/8 bytes) produced by the C++ shims.
#
# Verified behavior:
#   * 2048-bit Morgan FP -> 256 bytes; 1024-bit -> 128 bytes.
#   * Benzene produces a non-zero fingerprint.
@testset "Fingerprints" begin
    mol = smiles_to_mol("c1ccccc1")

    fp = morgan_fingerprint(mol)
    @test length(fp) == 256      # 2048 bits = 256 bytes
    @test any(b -> b != 0x00, fp)

    fp2 = morgan_fingerprint(mol; radius=3, nbits=1024)
    @test length(fp2) == 128     # 1024 bits = 128 bytes
    @test any(b -> b != 0x00, fp2)

    fp3 = rdkit_fingerprint(mol)
    @test length(fp3) > 0
    @test any(b -> b != 0x00, fp3)

    # Deterministic across independent calls on identical input.
    @test morgan_fingerprint(mol) == morgan_fingerprint(mol)
    @test rdkit_fingerprint(mol) == rdkit_fingerprint(mol)
end
