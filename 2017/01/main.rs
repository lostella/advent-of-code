use std::fs;
use std::io::{BufRead, BufReader};

fn solve1(digits: &Vec<u32>) -> u32 {
    let mut sum: u32 = 0;
    for k in 0..digits.len() {
        if digits[k] == digits[(k + 1) % digits.len()] {
            sum += digits[k]
        }
    }
    return sum;
}

fn solve2(digits: &Vec<u32>) -> u32 {
    let mut sum: u32 = 0;
    for k in 0..digits.len() {
        if digits[k] == digits[(k + digits.len() / 2) % digits.len()] {
            sum += digits[k]
        }
    }
    return sum;
}

fn main() {
    let file = fs::File::open("input").unwrap();
    let reader = BufReader::new(file);
    let line = reader.lines().next().unwrap().unwrap();
    let digits = line
        .chars()
        .map(|c| c.to_digit(10).unwrap())
        .collect::<Vec<u32>>();
    println!("{}", solve1(&digits));
    println!("{}", solve2(&digits));
}
