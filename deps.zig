const std = @import("std");

pub fn addAllTo(b: *std.build.Builder, exe: *std.build.CompileStep) void {
    const interface = b.createModule(.{ .source_file = .{ .path = "deps/interface/interface.zig" } });

    const msgstudio = b.createModule(.{
        .source_file = .{ .path = "msgstudio/src/lib.zig" },
        .dependencies = &.{.{ .name = "interface", .module = interface }},
    });
    exe.addModule("msgstudio", msgstudio);

    const util = b.createModule(.{.source_file = .{.path = "util/mod.zig"}});
    exe.addModule("util", util);
}
