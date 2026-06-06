# src/logging.jl
# Layer 3: Logging control

"""
    enable_logging()

Enable all RDKit logging.
"""
enable_logging() = ccall((:enable_logging, librdkitcffi), Cshort, ())

"""
    disable_logging()

Disable all RDKit logging.
"""
disable_logging() = ccall((:disable_logging, librdkitcffi), Cshort, ())

"""
    enable_logger(log_name)

Enable a specific RDKit logger by name.
"""
enable_logger(log_name::AbstractString) =
    ccall((:enable_logger, librdkitcffi), Cshort, (Cstring,), log_name)

"""
    disable_logger(log_name)

Disable a specific RDKit logger by name.
"""
disable_logger(log_name::AbstractString) =
    ccall((:disable_logger, librdkitcffi), Cshort, (Cstring,), log_name)

"""
    set_log_tee(log_name)

Set up a log tee that outputs to both buffer and default destination.
Returns an opaque log handle.
"""
set_log_tee(log_name::AbstractString) =
    ccall((:set_log_tee, librdkitcffi), Ptr{Cvoid}, (Cstring,), log_name)

"""
    set_log_capture(log_name)

Capture log output to a buffer.
Returns an opaque log handle.
"""
set_log_capture(log_name::AbstractString) =
    ccall((:set_log_capture, librdkitcffi), Ptr{Cvoid}, (Cstring,), log_name)

"""
    get_log_buffer(handle) -> String

Get the contents of the log buffer for a captured logger.
"""
function get_log_buffer(handle::Ptr{Cvoid})::String
    val = ccall((:get_log_buffer, librdkitcffi), Cstring, (Ptr{Cvoid},), handle)
    val == C_NULL && return ""
    return unsafe_string_and_free(val)
end

"""
    clear_log_buffer(handle)

Clear the log buffer for a captured logger.
"""
clear_log_buffer(handle::Ptr{Cvoid}) =
    ccall((:clear_log_buffer, librdkitcffi), Cshort, (Ptr{Cvoid},), handle)

"""
    destroy_log_handle(handle)

Destroy a log handle created by set_log_tee or set_log_capture.
"""
function destroy_log_handle(handle::Ptr{Cvoid})
    ref = Ref{Ptr{Cvoid}}(handle)
    ccall((:destroy_log_handle, librdkitcffi), Cshort, (Ref{Ptr{Cvoid}},), ref)
end

"""
    version() -> String

Get the RDKit version string.
"""
function version()::String
    val = ccall((:version, librdkitcffi), Cstring, ())
    return unsafe_string_and_free(val)
end
