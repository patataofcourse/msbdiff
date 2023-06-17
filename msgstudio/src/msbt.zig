const std = @import("std");
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;

const root = @import("root");
const LMSFile = root.common.LMSFile;
const LMSHashTable = root.common.LMSHashTable;

pub const Msbt = MsbtWithAttr(void);

pub const MsbtError = error{Test};

pub fn MsbtWithAttr(comptime Attr: type) type {
    return struct {
        strings: AutoHashMap([]u8, Message),
        attributes: ArrayList(Attr),

        pub fn new(allocator: *std.mem.Allocator) @This() {
            return @This(){
                .strings = AutoHashMap([]u8, Message).init(allocator.*),
                .attributes = ArrayList(Attr).init(allocator.*),
            };
        }

        pub fn from_lms_file(lms_file: *LMSFile) MsbtError!@This() {
            _ = lms_file;
            return MsbtError.Test;
        }

        pub fn to_lms_file(self: *@This()) MsbtError!LMSFile() {
            _ = self;
            return MsbtError.Test;
        }
    };
}

pub const Message = struct {
    string: String,
    style: u32, //indexes the MSBP
};

// might requre some extra stuff
pub const String = []u8;