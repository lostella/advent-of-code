use std::fs;
use std::io::{self, prelude::*};

fn line_to_int(bits: &String) -> u32 {
    let mut sum: u32 = 0;
    for c in bits.chars() {
        sum *= 2;
        sum += c.to_digit(2).unwrap();
    }
    sum
}

fn solve1(numbers: &Vec<u32>, nbits: u32) -> u32 {
    let count = numbers.len();
    let mut most_frequent: u32 = 0;
    for k in 0..nbits {
        let pow_2_k = u32::pow(2, k);
        if numbers.iter().filter(|&&n| (n & pow_2_k) > 0).count() > count / 2 {
            most_frequent |= pow_2_k;
        }
    }
    most_frequent * (u32::pow(2, nbits) - 1 - most_frequent)
}

fn is_majority(qty: usize, total: usize) -> bool {
    if total % 2 == 0 {
        qty >= total / 2
    } else {
        qty > total / 2
    }
}

fn is_minority(qty: usize, total: usize) -> bool { !is_majority(qty, total) }

fn find_rating(numbers: &Vec<u32>, nbits: u32, cond: fn(usize, usize) -> bool) -> u32 {
    let mut low: u32 = 0;
    let mut upp: u32 = u32::pow(2, nbits);
    let mut remaining: usize = numbers.len();
    for k in (0..nbits).rev() {
        let mid: u32 = low + u32::pow(2, k);
        let num_larger = numbers.iter().filter(|&&n| (mid <= n) && (n < upp)).count();
        if cond(num_larger, remaining) {
            low = mid;
            remaining = num_larger;
        } else {
            upp = mid;
            remaining -= num_larger;
        }
        if remaining == 1 {
            break;
        }
    }
    let remaining_numbers = numbers.iter().filter(|&&n| (low <= n) && (n < upp)).collect::<Vec<&u32>>();
    assert!(remaining_numbers.len() == 1);
    **remaining_numbers.first().unwrap()
}

fn solve2(numbers: &Vec<u32>, nbits: u32) -> u32 {
    find_rating(numbers, nbits, is_majority) * find_rating(numbers, nbits, is_minority)
}

fn main() {
    let file = fs::File::open("input").unwrap();
    let reader = io::BufReader::new(file);
    let lines: Vec<String> = reader.lines().map(std::result::Result::unwrap).collect();
    let nbits = lines.first().unwrap().len() as u32;
    let numbers: Vec<u32> = lines.iter().map(line_to_int).collect();

    println!("{}", solve1(&numbers, nbits));
    println!("{}", solve2(&numbers, nbits));
}
