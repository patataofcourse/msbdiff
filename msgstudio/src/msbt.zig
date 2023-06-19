const std = @import("std");
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;

const interface = @import("interface");
const SelfType = interface.SelfType;

const root = @import("lib.zig");
const LMSFile = root.common.LMSFile;
const LMSHashTable = root.common.LMSHashTable;

pub const Msbt = MsbtWithAttr(void);

pub const MsbtError = error{Todo, NotAnMsbt};

pub fn MsbtWithAttr(comptime Attr: type) type {
    return struct {
        const Self = @This();

        strings: AutoHashMap([]u8, Message(Attr)),

        pub fn new(allocator: std.mem.Allocator) Self {
            return Self {
                .strings = AutoHashMap([]u8, Message).init(allocator),
                .attributes = ArrayList(Attr).init(allocator),
            };
        }

        pub fn from_lms_file(allocator: std.mem.Allocator, lms_file: *LMSFile) MsbtError!*SelfType {
            const magic = "MsgStdBn".*;
            var blocks_slice = [_][4]u8{"LBL1".*, "TXT2".*};
            var blocks = ArrayList([4]u8).fromOwnedSlice(allocator, &blocks_slice);
            defer blocks.deinit();

            if (!std.mem.eql(u8, &magic, &lms_file.magic) or !lms_file.check_blocks(blocks, false)) {
                return MsbtError.NotAnMsbt;
            }
            //TODO: will have to use an Allocator somehow. and also convert pointer types or smth
            return MsbtError.Todo;
        }

        pub fn to_lms_file(self: *Self) MsbtError!LMSFile {
            _ = self;
            //TODO
            return MsbtError.Todo;
        }
    };
}

pub fn Message(comptime Attr: type) type {
    return struct {
        string: String,
        style: u32, //indexes the MSBP
        attribute: ?Attr,
    };
}

// might requre some extra stuff
pub const String = []u8;
