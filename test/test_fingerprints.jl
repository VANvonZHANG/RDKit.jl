# Fingerprints: the Julian accessors (src/fingerprints.jl) return the raw
# packed byte vector (ceil(nbits/8) bytes) produced by the C++ shims.
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

    # I-1 (final review): length + any-nonzero is tautological — a catastrophically
    # broken packing (wrong endianness, off-by-one shift, every bit set) would
    # still pass. Anchor on a deterministic popcount. Regression anchors —
    # RDKit-version-specific, mirroring the upstream jlRDKit_test/test.jl suite:
    # these are captured from a real run, stable across repeated runs because the
    # hash is seeded by atom/bond invariants (Morgan) or is fully deterministic
    # (RDKFP), never by RNG.
    @test sum(count_ones, fp) == 3   # benzene Morgan r=2 nBits=2048 -> 3 bits set

    # Distinguishability: two different molecules must produce different
    # fingerprints. If packing collapsed both inputs to the same bytes the shim
    # would be broken regardless of popcount.
    fp_ethanol = morgan_fingerprint(smiles_to_mol("CCO"))
    @test fp != fp_ethanol
    # Ethanol Morgan r=2 nBits=2048 -> 6 bits set (richer than benzene's 3).
    @test sum(count_ones, fp_ethanol) == 6

    # RDKit path-based fingerprint popcount anchor for benzene.
    @test sum(count_ones, fp3) == 12  # benzene RDKFP minPath=1 maxPath=7 -> 12 bits set

    # Non-multiple-of-8 nbits: byte count is ceil(nbits/8), not nbits÷8.
    fp_odd = morgan_fingerprint(mol; radius=2, nbits=100)
    @test length(fp_odd) == 13   # ceil(100/8) = 13
end
