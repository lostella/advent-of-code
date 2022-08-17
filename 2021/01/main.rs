use std::fs;
use std::io::{self, prelude::*};
use std::iter::zip;

fn solve1(data: &Vec<u32>) -> usize {
    zip(data[..data.len() - 1].iter(), data[1..].iter())
        .filter(|(a, b)| a < b)
        .count()
}

fn solve2(data: &Vec<u32>) -> usize {
    zip(data[..data.len() - 3].iter(), data[3..].iter())
        .filter(|(a, b)| a < b)
        .count()
}

fn main() {
    let file = fs::File::open("input").unwrap();
    let reader = io::BufReader::new(file);
    let values = reader
        .lines()
        .map(|line| line.unwrap().parse().unwrap())
        .collect::<Vec<u32>>();

    println!("{}", solve1(&values));
    println!("{}", solve2(&values));
}
