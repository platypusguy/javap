use std::env;
use std::path::Path;
use std::process::exit;

fn main() {
    // Collect the command line arguments into a vector
    let args: Vec<String> = env::args().collect();

    // args[0] = program name, so class file must be in args[i]
    if args.len() == 1 { // if none 
        println!("Usage: javap path_to_class_file");
        exit(1)
    }

    let file_path = &args[1];

    // Create a Path object
    let path = Path::new(file_path);

    // Check if the path exists and is a file
    if path.exists() && path.is_file() {
        println!("The file {} exists!", file_path);
        if path.is_file() {
            println!("and {} is a file.", file_path);
        } else {
            println!("but it's not a file.");
            exit(0)
        }
    } else {
        println!("The file {} does not exist.", file_path);
        exit(0)
    }
}
   