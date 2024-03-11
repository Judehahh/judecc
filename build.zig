const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // For flex and bison.
    const flex_cmd = b.addSystemCommand(&.{
        "flex",
        "-osrc/sysy.lex.c",
        "src/sysy.l",
    });
    const bison_cmd = b.addSystemCommand(&.{
        "bison",
        "-d",
        "src/sysy.y",
        "--defines=src/include/sysy.tab.h",
        "-osrc/sysy.tab.c",
    });

    const exe = b.addExecutable(.{
        .name = "sysy-compiler",
        .target = target,
        .optimize = optimize,
    });

    const cFlags = [_][]const u8{"-std=gnu11"};
    exe.addCSourceFile(.{ .file = .{ .path = "src/main.c" }, .flags = &cFlags });
    exe.addCSourceFile(.{ .file = .{ .path = "src/sysy.lex.c" }, .flags = &cFlags });
    exe.addCSourceFile(.{ .file = .{ .path = "src/sysy.tab.c" }, .flags = &cFlags });
    exe.addIncludePath(.{ .path = "src/include" });

    exe.linkLibC();
    exe.step.dependOn(&flex_cmd.step);
    exe.step.dependOn(&bison_cmd.step);

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
