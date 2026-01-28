const std = @import("std");
const Build = @import("std").Build;

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create the Zig module
    const zignav = b.addModule("root", .{
        .root_source_file = b.path("main.zig"),
    });
    zignav.addIncludePath(b.path("Recast/Include"));
    zignav.addIncludePath(b.path("Detour/Include"));
    zignav.addIncludePath(b.path("DetourTileCache/Include"));
    zignav.addIncludePath(b.path("DetourCrowd/Include"));

    // Create a static library for the C++ code
    const zignav_c_cpp = b.addLibrary(.{
        .name = "zignav_c_cpp",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(zignav_c_cpp);

    zignav_c_cpp.root_module.addIncludePath(b.path("Recast/Include"));
    zignav_c_cpp.root_module.addIncludePath(b.path("Detour/Include"));
    zignav_c_cpp.root_module.addIncludePath(b.path("DetourTileCache/Include"));
    zignav_c_cpp.root_module.addIncludePath(b.path("DetourCrowd/Include"));
    zignav_c_cpp.root_module.link_libc = true;
    zignav_c_cpp.root_module.link_libcpp = true;

    zignav_c_cpp.root_module.addCSourceFiles(.{
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
}
