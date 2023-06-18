const std = @import("std");
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;

const interface = @import("interface");
const SelfType = interface.SelfType;

const root = @import("lib.zig");
const LMSFile = root.common.LMSFile;
const LMSHashTable = root.common.LMSHashTable;

pub const Msbt = MsbtWithAttr(void);

pub const MsbtError = error{Todo};

pub fn MsbtWithAttr(comptime Attr: type) type {
    return struct {
        const Self = @This();

        strings: AutoHashMap([]u8, Message),
        attributes: ArrayList(Attr),

        pub fn new(allocator: std.mem.Allocator) Self {
            return Self {
                .strings = AutoHashMap([]u8, Message).init(allocator),
                .attributes = ArrayList(Attr).init(allocator),
            };
        }

        pub fn from_lms_file(lms_file: *LMSFile) MsbtError!*SelfType {
            _ = lms_file;
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

pub const Message = struct {
    string: String,
    style: u32, //indexes the MSBP
};

// might requre some extra stuff
pub const String = []u8;
