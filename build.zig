const std = @import("std");
const Build = @import("std").Build;

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Just export the module
    _ = b.addModule("zignav", .{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });
}
