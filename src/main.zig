const std = @import("std");

const msgstudio = @import("msgstudio");

pub fn main() !void {
    var gpa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer gpa.deinit();
    const allocator = gpa.allocator();

    var file = try std.fs.cwd().openFile("test_files/agb.msbt", .{});
    var lms_file = try msgstudio.common.LMSFile.from_file(allocator, &file);
    // std.log.info("{}\n", .{lms_file});
    // for (lms_file.blocks.items) |block| {
    //     std.log.info("block type {s}", .{block.block_type});
    // }
    var file_w = try std.fs.cwd().createFile("test_files/agb.msbt.out", .{});
    try lms_file.to_file(&file_w, std.builtin.Endian.Little);
}
