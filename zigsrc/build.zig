const std = @import("std");
const Build = @import("std").Build;

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const exe = b.addExecutable(.{
        .name = "ZigNavDemo",
        .use_llvm = true,
        .root_module = b.createModule(.{
            .root_source_file = b.path("demo.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const zignav_dep = b.dependency("zignav", .{
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("zignav", zignav_dep.module("zignav"));

    exe.linkLibCpp();
    exe.addIncludePath(zignav_dep.path("Recast/Include"));
    exe.addIncludePath(zignav_dep.path("Detour/Include"));
    exe.addIncludePath(zignav_dep.path("DetourTileCache/Include"));
    exe.addIncludePath(zignav_dep.path("DetourCrowd/Include"));

    exe.addCSourceFiles(.{
        .root = zignav_dep.path(""),
        .files = &.{
            "Recast/Include/Recast_glue.cpp",
            "Recast/Source/Recast.cpp",
            "Recast/Source/RecastAlloc.cpp",
            "Recast/Source/RecastArea.cpp",
            "Recast/Source/RecastAssert.cpp",
            "Recast/Source/RecastContour.cpp",
            "Recast/Source/RecastFilter.cpp",
            "Recast/Source/RecastLayers.cpp",
            "Recast/Source/RecastMesh.cpp",
            "Recast/Source/RecastMeshDetail.cpp",
            "Recast/Source/RecastRasterization.cpp",
            "Recast/Source/RecastRegion.cpp",
            "Detour/Include/DetourAlloc_glue.cpp",
            "Detour/Include/DetourAssert_glue.cpp",
            "Detour/Include/DetourCommon_glue.cpp",
            "Detour/Include/DetourNavMesh_glue.cpp",
            "Detour/Include/DetourNavMeshBuilder_glue.cpp",
            "Detour/Include/DetourNavMeshQuery_glue.cpp",
            "Detour/Include/DetourNode_glue.cpp",
            "Detour/Include/DetourStatus_glue.cpp",
            "Detour/Source/DetourAlloc.cpp",
            "Detour/Source/DetourAssert.cpp",
            "Detour/Source/DetourCommon.cpp",
            "Detour/Source/DetourNavMesh.cpp",
            "Detour/Source/DetourNavMeshBuilder.cpp",
            "Detour/Source/DetourNavMeshQuery.cpp",
            "Detour/Source/DetourNode.cpp",
            "DetourTileCache/Include/DetourTileCache_glue.cpp",
            "DetourTileCache/Include/DetourTileCacheBuilder_glue.cpp",
            "DetourTileCache/Source/DetourTileCache.cpp",
            "DetourTileCache/Source/DetourTileCacheBuilder.cpp",
            "DetourCrowd/Include/DetourPathCorridor_glue.cpp",
            "DetourCrowd/Source/DetourPathCorridor.cpp",
        },
        .flags = &.{},
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
