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

    exe.root_module.addImport("zignav", zignav_dep.module("root"));
    exe.root_module.linkLibrary(zignav_dep.artifact("zignav_c_cpp"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
