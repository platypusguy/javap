const std = @import("std");

pub fn main() anyerror!void {
    // == get the CLI args ==
    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // Parse args into string array (error union needs 'try')
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if( args.len < 2 ) { // arg[0] is executable's filename, arg[1] is first true CLI arg
        std.debug.print("javap expects a the name of a class file\n", .{});
    } else {
        // Get and print them!
        std.debug.print("There are {d} args:\n", .{args.len});
        for(args) |arg| {
            std.debug.print("  {s}\n", .{arg});
        }
    }


    // const arg_it = std.os.args();
    //
    // // create an array list to hold the CLI strings
    // const allocator = std.heap.page_allocator;
    // var args = std.ArrayList([]const u8).init(allocator);
    // defer args.deinit();
    //
    // // load the CLI strings into the array list
    // while (try arg_it.next()) |arg| {
    //     try args.append(arg);
    // }
    //
    // var i = 0;
    // for (args.items) |arg| {
    //     std.debug.print("arg[{}] = {}\n", .{ i, arg });
    //     i += 1;
    // }
    //
    //
    //
    // // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    // std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    //
    // // stdout is for the actual output of your application, for example if you
    // // are implementing gzip, then only the compressed bytes should be sent to
    // // stdout, not any debugging messages.
    // const stdout_file = std.io.getStdOut().writer();
    // var bw = std.io.bufferedWriter(stdout_file);
    // const stdout = bw.writer();
    //
    // try stdout.print("Run `zig build test` to run the tests.\n", .{});
    //
    // try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
