# src/ctypes.jl
# AUTO-GENERATED from cffiwrapper.h — DO NOT EDIT MANUALLY
# Layer 1: Raw ccall bindings for RDKit CFFI

const librdkitcffi = RDKit_jll.librdkitcffi

# ---------------------------------------------------------------------------
# I/O
# ---------------------------------------------------------------------------

function get_mol(input::Cstring, mol_sz::Ref{Csize_t}, details_json::Cstring)
    @ccall librdkitcffi.get_mol(input::Cstring, mol_sz::Ref{Csize_t},
                                details_json::Cstring)::Cstring
end

function get_qmol(input::Cstring, mol_sz::Ref{Csize_t}, details_json::Cstring)
    @ccall librdkitcffi.get_qmol(input::Cstring, mol_sz::Ref{Csize_t},
                                 details_json::Cstring)::Cstring
end

function get_molblock(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_molblock(pkl::Cstring, pkl_sz::Csize_t,
                                     details_json::Cstring)::Cstring
end

function get_v3kmolblock(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_v3kmolblock(pkl::Cstring, pkl_sz::Csize_t,
                                        details_json::Cstring)::Cstring
end

function get_v2kmolblock(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_v2kmolblock(pkl::Cstring, pkl_sz::Csize_t,
                                        details_json::Cstring)::Cstring
end

function get_smiles(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_smiles(pkl::Cstring, pkl_sz::Csize_t,
                                   details_json::Cstring)::Cstring
end

function get_smarts(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_smarts(pkl::Cstring, pkl_sz::Csize_t,
                                   details_json::Cstring)::Cstring
end

function get_cxsmiles(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_cxsmiles(pkl::Cstring, pkl_sz::Csize_t,
                                     details_json::Cstring)::Cstring
end

function get_cxsmarts(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_cxsmarts(pkl::Cstring, pkl_sz::Csize_t,
                                     details_json::Cstring)::Cstring
end

function get_json(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_json(pkl::Cstring, pkl_sz::Csize_t,
                                 details_json::Cstring)::Cstring
end

# InChI support (built in JLL)
function get_inchi(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_inchi(pkl::Cstring, pkl_sz::Csize_t,
                                  details_json::Cstring)::Cstring
end

function get_inchi_for_molblock(ctab::Cstring, details_json::Cstring)
    @ccall librdkitcffi.get_inchi_for_molblock(ctab::Cstring,
                                               details_json::Cstring)::Cstring
end

function get_inchikey_for_inchi(inchi::Cstring)
    @ccall librdkitcffi.get_inchikey_for_inchi(inchi::Cstring)::Cstring
end

function get_rxn(input::Cstring, mol_sz::Ref{Csize_t}, details_json::Cstring)
    @ccall librdkitcffi.get_rxn(input::Cstring, mol_sz::Ref{Csize_t},
                                details_json::Cstring)::Cstring
end

function get_mol_frags(pkl::Cstring, pkl_sz::Csize_t,
                       frags_pkl_sz_array::Ref{Ptr{Csize_t}},
                       num_frags::Ref{Csize_t}, details_json::Cstring,
                       mappings_json::Ref{Cstring})
    @ccall librdkitcffi.get_mol_frags(pkl::Cstring, pkl_sz::Csize_t,
                                      frags_pkl_sz_array::Ref{Ptr{Csize_t}},
                                      num_frags::Ref{Csize_t},
                                      details_json::Cstring,
                                      mappings_json::Ref{Cstring})::Ptr{Cstring}
end

# ---------------------------------------------------------------------------
# Substructure
# ---------------------------------------------------------------------------

function get_substruct_match(mol_pkl::Cstring, mol_pkl_sz::Csize_t,
                             query_pkl::Cstring, query_pkl_sz::Csize_t,
                             options_json::Cstring)
    @ccall librdkitcffi.get_substruct_match(mol_pkl::Cstring, mol_pkl_sz::Csize_t,
                                            query_pkl::Cstring, query_pkl_sz::Csize_t,
                                            options_json::Cstring)::Cstring
end

function get_substruct_matches(mol_pkl::Cstring, mol_pkl_sz::Csize_t,
                               query_pkl::Cstring, query_pkl_sz::Csize_t,
                               options_json::Cstring)
    @ccall librdkitcffi.get_substruct_matches(mol_pkl::Cstring, mol_pkl_sz::Csize_t,
                                              query_pkl::Cstring, query_pkl_sz::Csize_t,
                                              options_json::Cstring)::Cstring
end

# ---------------------------------------------------------------------------
# Drawing
# ---------------------------------------------------------------------------

function get_svg(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_svg(pkl::Cstring, pkl_sz::Csize_t,
                                details_json::Cstring)::Cstring
end

function get_rxn_svg(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_rxn_svg(pkl::Cstring, pkl_sz::Csize_t,
                                    details_json::Cstring)::Cstring
end

# ---------------------------------------------------------------------------
# Calculators
# ---------------------------------------------------------------------------

function get_descriptors(pkl::Cstring, pkl_sz::Csize_t)
    @ccall librdkitcffi.get_descriptors(pkl::Cstring, pkl_sz::Csize_t)::Cstring
end

function get_morgan_fp(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_morgan_fp(pkl::Cstring, pkl_sz::Csize_t,
                                      details_json::Cstring)::Cstring
end

function get_morgan_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                                nbytes::Ref{Csize_t}, details_json::Cstring)
    @ccall librdkitcffi.get_morgan_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                                               nbytes::Ref{Csize_t},
                                               details_json::Cstring)::Cstring
end

function get_rdkit_fp(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_rdkit_fp(pkl::Cstring, pkl_sz::Csize_t,
                                     details_json::Cstring)::Cstring
end

function get_rdkit_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                               nbytes::Ref{Csize_t}, details_json::Cstring)
    @ccall librdkitcffi.get_rdkit_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                                              nbytes::Ref{Csize_t},
                                              details_json::Cstring)::Cstring
end

function get_pattern_fp(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_pattern_fp(pkl::Cstring, pkl_sz::Csize_t,
                                       details_json::Cstring)::Cstring
end

function get_pattern_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                                 nbytes::Ref{Csize_t}, details_json::Cstring)
    @ccall librdkitcffi.get_pattern_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                                                nbytes::Ref{Csize_t},
                                                details_json::Cstring)::Cstring
end

function get_topological_torsion_fp(pkl::Cstring, pkl_sz::Csize_t,
                                    details_json::Cstring)
    @ccall librdkitcffi.get_topological_torsion_fp(pkl::Cstring, pkl_sz::Csize_t,
                                                   details_json::Cstring)::Cstring
end

function get_topological_torsion_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                                             nbytes::Ref{Csize_t},
                                             details_json::Cstring)
    @ccall librdkitcffi.get_topological_torsion_fp_as_bytes(
        pkl::Cstring, pkl_sz::Csize_t, nbytes::Ref{Csize_t},
        details_json::Cstring)::Cstring
end

function get_atom_pair_fp(pkl::Cstring, pkl_sz::Csize_t, details_json::Cstring)
    @ccall librdkitcffi.get_atom_pair_fp(pkl::Cstring, pkl_sz::Csize_t,
                                         details_json::Cstring)::Cstring
end

function get_atom_pair_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                                   nbytes::Ref{Csize_t}, details_json::Cstring)
    @ccall librdkitcffi.get_atom_pair_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                                                  nbytes::Ref{Csize_t},
                                                  details_json::Cstring)::Cstring
end

function get_maccs_fp(pkl::Cstring, pkl_sz::Csize_t)
    @ccall librdkitcffi.get_maccs_fp(pkl::Cstring, pkl_sz::Csize_t)::Cstring
end

function get_maccs_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                               nbytes::Ref{Csize_t})
    @ccall librdkitcffi.get_maccs_fp_as_bytes(pkl::Cstring, pkl_sz::Csize_t,
                                              nbytes::Ref{Csize_t})::Cstring
end

# NOTE: Avalon fingerprint functions are NOT available — Avalon is not built in JLL

# ---------------------------------------------------------------------------
# Modification
# ---------------------------------------------------------------------------

function add_hs(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t})
    @ccall librdkitcffi.add_hs(pkl::Ref{Cstring},
                               pkl_sz::Ref{Csize_t})::Cshort
end

function remove_all_hs(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t})
    @ccall librdkitcffi.remove_all_hs(pkl::Ref{Cstring},
                                      pkl_sz::Ref{Csize_t})::Cshort
end

function remove_hs(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                   details_json::Cstring)
    @ccall librdkitcffi.remove_hs(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                                  details_json::Cstring)::Cshort
end

# ---------------------------------------------------------------------------
# Standardization
# ---------------------------------------------------------------------------

function cleanup(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                 details_json::Cstring)
    @ccall librdkitcffi.cleanup(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                                details_json::Cstring)::Cshort
end

function normalize(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                   details_json::Cstring)
    @ccall librdkitcffi.normalize(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                                  details_json::Cstring)::Cshort
end

function neutralize(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                    details_json::Cstring)
    @ccall librdkitcffi.neutralize(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                                   details_json::Cstring)::Cshort
end

function reionize(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                  details_json::Cstring)
    @ccall librdkitcffi.reionize(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                                 details_json::Cstring)::Cshort
end

function canonical_tautomer(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                            details_json::Cstring)
    @ccall librdkitcffi.canonical_tautomer(pkl::Ref{Cstring},
                                           pkl_sz::Ref{Csize_t},
                                           details_json::Cstring)::Cshort
end

function charge_parent(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                       details_json::Cstring)
    @ccall librdkitcffi.charge_parent(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                                      details_json::Cstring)::Cshort
end

function fragment_parent(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                         details_json::Cstring)
    @ccall librdkitcffi.fragment_parent(pkl::Ref{Cstring},
                                        pkl_sz::Ref{Csize_t},
                                        details_json::Cstring)::Cshort
end

# ---------------------------------------------------------------------------
# Coordinates
# ---------------------------------------------------------------------------

function prefer_coordgen(val::Cshort)
    @ccall librdkitcffi.prefer_coordgen(val::Cshort)::Cvoid
end

function has_coords(mol_pkl::Cstring, mol_pkl_sz::Csize_t)
    @ccall librdkitcffi.has_coords(mol_pkl::Cstring,
                                   mol_pkl_sz::Csize_t)::Cshort
end

function set_2d_coords(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t})
    @ccall librdkitcffi.set_2d_coords(pkl::Ref{Cstring},
                                      pkl_sz::Ref{Csize_t})::Cshort
end

function set_3d_coords(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                       params_json::Cstring)
    @ccall librdkitcffi.set_3d_coords(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                                      params_json::Cstring)::Cshort
end

function set_2d_coords_aligned(pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
                               template_pkl::Cstring, template_sz::Csize_t,
                               details_json::Cstring,
                               match_json::Ref{Cstring})
    @ccall librdkitcffi.set_2d_coords_aligned(
        pkl::Ref{Cstring}, pkl_sz::Ref{Csize_t},
        template_pkl::Cstring, template_sz::Csize_t,
        details_json::Cstring,
        match_json::Ref{Cstring})::Cshort
end

# ---------------------------------------------------------------------------
# Housekeeping
# ---------------------------------------------------------------------------

function free_ptr(ptr::Cstring)
    @ccall librdkitcffi.free_ptr(ptr::Cstring)::Cvoid
end

function version()
    @ccall librdkitcffi.version()::Cstring
end

function enable_logging()
    @ccall librdkitcffi.enable_logging()::Cshort
end

function enable_logger(log_name::Cstring)
    @ccall librdkitcffi.enable_logger(log_name::Cstring)::Cshort
end

function disable_logging()
    @ccall librdkitcffi.disable_logging()::Cshort
end

function disable_logger(log_name::Cstring)
    @ccall librdkitcffi.disable_logger(log_name::Cstring)::Cshort
end

# ---------------------------------------------------------------------------
# Chirality
# ---------------------------------------------------------------------------

function use_legacy_stereo_perception(value::Cshort)
    @ccall librdkitcffi.use_legacy_stereo_perception(value::Cshort)::Cshort
end

function allow_non_tetrahedral_chirality(value::Cshort)
    @ccall librdkitcffi.allow_non_tetrahedral_chirality(value::Cshort)::Cshort
end

# ---------------------------------------------------------------------------
# PNG metadata
# ---------------------------------------------------------------------------

function add_mol_to_png_blob(png_blob::Ref{Cstring}, png_blob_sz::Ref{Csize_t},
                             mpkl::Cstring, mpkl_size::Csize_t,
                             details_json::Cstring)
    @ccall librdkitcffi.add_mol_to_png_blob(
        png_blob::Ref{Cstring}, png_blob_sz::Ref{Csize_t},
        mpkl::Cstring, mpkl_size::Csize_t,
        details_json::Cstring)::Cshort
end

function get_mol_from_png_blob(png_blob::Cstring, png_blob_sz::Csize_t,
                               mpkl::Ref{Cstring}, mpkl_sz::Ref{Csize_t},
                               details_json::Cstring)
    @ccall librdkitcffi.get_mol_from_png_blob(
        png_blob::Cstring, png_blob_sz::Csize_t,
        mpkl::Ref{Cstring}, mpkl_sz::Ref{Csize_t},
        details_json::Cstring)::Cshort
end

function get_mols_from_png_blob(png_blob::Cstring, png_blob_sz::Csize_t,
                                mpkl_array::Ref{Ptr{Ptr{Cstring}}},
                                mpkl_sz_array::Ref{Ptr{Csize_t}},
                                details_json::Cstring)
    @ccall librdkitcffi.get_mols_from_png_blob(
        png_blob::Cstring, png_blob_sz::Csize_t,
        mpkl_array::Ref{Ptr{Ptr{Cstring}}},
        mpkl_sz_array::Ref{Ptr{Csize_t}},
        details_json::Cstring)::Cshort
end

function free_mol_array(pkl_array::Ref{Ptr{Ptr{Cstring}}},
                        pkl_sz_array::Ref{Ptr{Csize_t}})
    @ccall librdkitcffi.free_mol_array(
        pkl_array::Ref{Ptr{Ptr{Cstring}}},
        pkl_sz_array::Ref{Ptr{Csize_t}})::Cvoid
end

# ---------------------------------------------------------------------------
# Logging handles
# ---------------------------------------------------------------------------

function set_log_tee(log_name::Cstring)
    @ccall librdkitcffi.set_log_tee(log_name::Cstring)::Ptr{Cvoid}
end

function set_log_capture(log_name::Cstring)
    @ccall librdkitcffi.set_log_capture(log_name::Cstring)::Ptr{Cvoid}
end

function destroy_log_handle(log_handle::Ref{Ptr{Cvoid}})
    @ccall librdkitcffi.destroy_log_handle(log_handle::Ref{Ptr{Cvoid}})::Cshort
end

function get_log_buffer(log_handle::Ptr{Cvoid})
    @ccall librdkitcffi.get_log_buffer(log_handle::Ptr{Cvoid})::Cstring
end

function clear_log_buffer(log_handle::Ptr{Cvoid})
    @ccall librdkitcffi.clear_log_buffer(log_handle::Ptr{Cvoid})::Cshort
end

# ---------------------------------------------------------------------------
# Properties
# ---------------------------------------------------------------------------

function has_prop(mol_pkl::Cstring, mol_pkl_sz::Csize_t, key::Cstring)
    @ccall librdkitcffi.has_prop(mol_pkl::Cstring, mol_pkl_sz::Csize_t,
                                 key::Cstring)::Cshort
end

function get_prop_list(mol_pkl::Cstring, mol_pkl_sz::Csize_t,
                       includePrivate::Cshort, includeComputed::Cshort)
    @ccall librdkitcffi.get_prop_list(mol_pkl::Cstring, mol_pkl_sz::Csize_t,
                                      includePrivate::Cshort,
                                      includeComputed::Cshort)::Ptr{Cstring}
end

function set_prop(mol_pkl::Ref{Cstring}, mol_pkl_sz::Ref{Csize_t},
                  key::Cstring, val::Cstring, computed::Cshort)
    @ccall librdkitcffi.set_prop(mol_pkl::Ref{Cstring}, mol_pkl_sz::Ref{Csize_t},
                                 key::Cstring, val::Cstring,
                                 computed::Cshort)::Cvoid
end

function get_prop(mol_pkl::Cstring, mol_pkl_sz::Csize_t, key::Cstring)
    @ccall librdkitcffi.get_prop(mol_pkl::Cstring, mol_pkl_sz::Csize_t,
                                 key::Cstring)::Cstring
end

function clear_prop(mol_pkl::Ref{Cstring}, mol_pkl_sz::Ref{Csize_t},
                    key::Cstring)
    @ccall librdkitcffi.clear_prop(mol_pkl::Ref{Cstring},
                                   mol_pkl_sz::Ref{Csize_t},
                                   key::Cstring)::Cshort
end

function keep_props(mol_pkl::Ref{Cstring}, mol_pkl_sz::Ref{Csize_t},
                    details_json::Cstring)
    @ccall librdkitcffi.keep_props(mol_pkl::Ref{Cstring},
                                   mol_pkl_sz::Ref{Csize_t},
                                   details_json::Cstring)::Cvoid
end
