use std::env;
use std::fs;

fn main() {
    let path = env::current_exe().expect("Error while getting executable path")
        .parent().expect("Error while getting parent path")
        .join("input");

    let content = fs::read_to_string(path).expect("Error while reading file");  

    for line in content.lines() {
        println!("{}", line)
    }
}
