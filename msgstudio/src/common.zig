const std = @import("std");
const ArrayList = std.ArrayList;

const interface = @import("interface");
const Interface = interface.Interface;
const SelfType = interface.SelfType;

pub const LMSFile = struct {
    version: u8,
    blocks: ArrayList(LMSBlock),
};

pub const LMSBlock = struct {
    block_type: [4]u8,
    data: ArrayList(u8),
};

pub fn LMSFileKind(comptime Error: type) type {
    return Interface(struct {
        from_lms_file: fn (*LMSFile) Error!*SelfType,
        to_lms_file: fn (*SelfType) Error!LMSFile,
    }, interface.Storage.Owning);
}

pub const LMSHashTable = struct { slots: ArrayList(LMSHashSlot) };

pub const LMSHashSlot = struct { labels: ArrayList(LMSHashLabel) };

pub const LMSHashLabel = struct { string: []u8, index: u32 };
