const std = @import("std");

const msgstudio = @import("msgstudio");

pub const err = @import("error.zig");

pub var gAllocator: std.mem.Allocator = undefined;

pub fn run() !void {
    var gpa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer gpa.deinit();
    gAllocator = gpa.allocator();
    const allocator = gAllocator;

    var file = try std.fs.cwd().openFile("test_files/agb.msbt", .{});
    var lms_file = try msgstudio.common.LMSFile.from_file(allocator, &file);

    //var file_w = try std.fs.cwd().createFile("test_files/agb.msbt.out", .{});
    //try lms_file.to_file(&file_w, std.builtin.Endian.Little);

    var msbt = try msgstudio.msbt.Msbt.from_lms_file(allocator, &lms_file);
    _ = msbt;
}


pub fn main() !void {
    const ret = run();
    if (ret) |_| {

    } else |e| switch (e) {
        //TODO: add more information somehow
        error.Todo => {std.log.err("whatever you tried to run is a TODO", .{});},
        else => try ret,
    }
}