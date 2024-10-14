//? This is a version of javap that emulates the utility in HotSpot. Give it the name of a class file
//? And it defaults to the equivalent of HotSpots javap -v -private -l filename
//? The listing is output to filename (without the path or the class extension).javap.txt
//? (c) 2024 the Jacobin Authors. Note this is experimental code for learning Zig

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
        std.process.exit(0);
    }

    // now, open the file in arg[1]
    const path = args[1];

    // Attempt to open the file
    const class_file = std.fs.cwd().openFile(path, .{}) catch |err| {
        std.debug.print("Failed to open {s} due to: {}\n", .{path, err});
        std.process.exit(0);
    };
    defer class_file.close(); // Don't forget to close the file when done

    // Read file into byte buffer
    const file_stat  = try class_file.stat();
    const file_size = file_stat.size;
    var buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);
    _ = class_file.readAll(buffer) catch |err| {
        std.debug.print("Failed to read {s} due to: {}\n", .{path, err});
        std.process.exit(0);
    };

    if ((buffer[0] != 0xCA) or (buffer[1]  != 0xFE) or (buffer[2] != 0xBA) or (buffer[3] != 0xBE)) {
        std.debug.print("{s} is not a valid Java class file\n", .{path});
        std.process.exit(0);
    } else {
        buffer[0] = 0xCA;
    }

    std.debug.print("File {s} opened successfully.\n", .{path});

}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
