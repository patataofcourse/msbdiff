const stdout = @import("std").io.getStdOut().writer();

/// regular old print
pub fn print(comptime format: []const u8, args: anytype) void {
    stdout.print(format, args) catch {
        @panic("util.stdout.print panicked with error");
    };
}

/// print + line break
pub fn println(comptime format: []const u8, args: anytype) void {
    stdout.print(format ++ "\n", args) catch {
        @panic("util.stdout.println panicked with error");
    };
}

/// Quick pRINT
pub fn qrint(comptime string: []const u8) void {
    stdout.print(string, .{}) catch {
        @panic("util.stdout.print panicked with error");
    };
}

/// Quick pRINT + LiNe break
pub fn qrintln(comptime string: []const u8) void {
    stdout.print(string ++ "\n", .{}) catch {
        @panic("util.stdout.println panicked with error");
    };
}