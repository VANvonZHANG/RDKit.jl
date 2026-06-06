# src/drawing.jl

"""
    get_svg(mol[, details]) -> String

Generate an SVG depiction of the molecule.
"""
function get_svg(mol::Mol, details::Union{Dict{String,Any},Nothing}=nothing)::String
    details_json = jsonify_details(details)
    val = ccall((:get_svg, librdkitcffi), Cstring,
                (Cstring, Csize_t, Cstring),
                mol.pkl[], mol.pkl_size[], details_json)
    return unsafe_string_and_free(val)
end

"""
    get_rxn_svg(rxn[, details]) -> String

Generate an SVG depiction of a reaction.
"""
function get_rxn_svg(rxn::Reaction, details::Union{Dict{String,Any},Nothing}=nothing)::String
    details_json = jsonify_details(details)
    val = ccall((:get_rxn_svg, librdkitcffi), Cstring,
                (Cstring, Csize_t, Cstring),
                rxn.pkl[], rxn.pkl_size[], details_json)
    return unsafe_string_and_free(val)
end
