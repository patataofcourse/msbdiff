const std = @import("std");
const root = @import("root");

pub var gErrorPayload: ?*anyopaque = null;

//TODO: make this work

pub const TodoPayload = struct { *const [:0]u8 };

pub fn err(comptime T: type, e: anyerror, payload: T) !void {
    gErrorPayload = &((root.gAllocator.alloc(T, 1) catch {@panic("could not allocate error payload");})[0]);
    @as(*T, @ptrCast(@alignCast(gErrorPayload))).* = payload;
    return e;
}