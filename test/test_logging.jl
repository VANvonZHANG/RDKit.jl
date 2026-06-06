using Test
using RDKit

@testset "Logging" begin
    @testset "enable/disable logging" begin
        enable_logging()
        disable_logging()
        @test true
    end

    @testset "enable/disable logger" begin
        enable_logger("rdkit.debug")
        disable_logger("rdkit.debug")
        @test true
    end

    @testset "log capture" begin
        handle = set_log_capture("rdkit.info")
        @test handle !== nothing
        buffer = get_log_buffer(handle)
        clear_log_buffer(handle)
        destroy_log_handle(handle)
        @test true
    end

    @testset "log tee" begin
        handle = set_log_tee("rdkit.warning")
        @test handle !== nothing
        destroy_log_handle(handle)
        @test true
    end

    @testset "version" begin
        v = version()
        @test v !== nothing
        @test typeof(v) == String
        @test length(v) > 0
    end
end
