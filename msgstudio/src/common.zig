const std = @import("std");
const ArrayList = std.ArrayList;

const interface = @import("interface");
const Interface = interface.Interface;
const SelfType = interface.SelfType;

pub const LMSError = error{ WrongBOM, UnsupportedVersion };

pub const Endian = std.builtin.Endian;
pub const Encoding = enum(u8) { UTF8 = 0, UTF16 = 1, UTF32 = 2 };

pub const LMSFile = struct {
    magic: [8]u8,
    encoding: Encoding,
    version: u8,
    unknown: [16]u8,
    blocks: ArrayList(LMSBlock),

    const Self = @This();

    pub fn from_file(allocator: std.mem.Allocator, file: *std.fs.File) !Self {
        var reader = file.reader();
        return Self.from_reader(allocator, std.fs.File, std.fs.File.ReadError, std.fs.File.read, &reader);
    }

    pub fn to_file(self: Self, file: *std.fs.File, endian: Endian) !void {
        var writer = file.writer();
        return self.to_writer(std.fs.File, std.fs.File.WriteError, std.fs.File.write, &writer, endian);
    }

    pub fn from_reader(
        allocator: std.mem.Allocator,
        comptime Context: type,
        comptime ReadError: type,
        comptime readFn: fn (Context, []u8) ReadError!usize,
        file: *std.io.Reader(Context, ReadError, readFn)
    ) !Self {
        var buf_reader = std.io.bufferedReader(file.*);
        var in_stream = buf_reader.reader();

        const magic = try in_stream.readBoundedBytes(8);
        const endian = blk: {
            const bom = try in_stream.readIntBig(u16);
            if (bom == 0xFFFE) {
                break :blk Endian.Little;
            } else if (bom == 0xFEFF) {
                break :blk Endian.Big;
            } else {
                return LMSError.WrongBOM;
            }
        };

        try in_stream.skipBytes(2, .{});
        const encoding = try in_stream.readEnum(Encoding, endian);
        const version = try in_stream.readByte();

        if (version != 3) {
            return LMSError.UnsupportedVersion;
        }

        const num_blocks = try in_stream.readInt(u16, endian);
        const unknown = try in_stream.readBoundedBytes(16);

        var blocks = try ArrayList(LMSBlock).initCapacity(allocator, num_blocks);
        for (0..num_blocks) |_| {
            const block_type = try in_stream.readBoundedBytes(4);
            const size = try in_stream.readInt(u32, endian);
            try in_stream.skipBytes(8, .{});

            var block_data = try ArrayList(u8).initCapacity(allocator, size);
            try block_data.appendNTimes(0, size);
            try in_stream.readNoEof(block_data.items);
            try blocks.append(.{ .block_type = block_type.buffer, .data = block_data });
            try in_stream.skipBytes((16 - (size % 16)) % 16, .{});
        }

        return LMSFile{
            .magic = magic.buffer,
            .encoding = encoding,
            .version = version,
            .unknown = unknown.buffer,
            .blocks = blocks,
        };
    }

    pub fn to_writer(
        self: Self,
        comptime Context: type,
        comptime WriteError: type,
        comptime writeFn: fn (Context, []const u8) WriteError!usize,
        file: *std.io.Writer(Context, WriteError, writeFn),
        endian: Endian,
    ) !void {
        var buf_writer = std.io.bufferedWriter(file.*);
        defer buf_writer.flush() catch {};
        var out_stream = buf_writer.writer();

        try out_stream.writeAll(&self.magic);
        try out_stream.writeInt(u16, 0xFEFF, endian);
        try out_stream.writeByteNTimes(0, 2);

        try out_stream.writeByte(@enumToInt(self.encoding));
        try out_stream.writeByte(self.version);

        try out_stream.writeInt(u16, @intCast(u16, self.blocks.items.len), endian);
        try out_stream.writeAll(&self.unknown);

        for (self.blocks.items) |block| {
            try out_stream.writeAll(&block.block_type);
            const size = block.data.items.len;
            try out_stream.writeInt(u32, @intCast(u32, block.data.items.len), endian);
            try out_stream.writeByteNTimes(0, 8);

            try out_stream.writeAll(block.data.items);
            std.log.warn("{x} {x}", .{size, (16 - (size % 16)) % 16});
            try out_stream.writeByteNTimes(0xAB, (16 - (size % 16)) % 16);
        }

        return;
    }
};

pub const LMSBlock = struct {
    block_type: [4]u8,
    data: ArrayList(u8),
};

pub fn LMSFileKind(comptime Error: type) type {
    return Interface(struct {
        from_lms_file: *const fn (*LMSFile) Error!*SelfType,
        to_lms_file: *const fn (*SelfType) Error!LMSFile,
    }, interface.Storage.Owning);
}

pub const LMSHashTable = struct { slots: ArrayList(LMSHashSlot) };

pub const LMSHashSlot = struct { labels: ArrayList(LMSHashLabel) };

pub const LMSHashLabel = struct { string: []u8, index: u32 };
