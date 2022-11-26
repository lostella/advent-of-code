use std::fs;
use std::io::{self, BufRead};

fn solve1(data: &Vec<Vec<u32>>) -> u32 {
    let mut sum: u32 = 0;
    for row in data {
        sum += row.iter().max().unwrap() - row.iter().min().unwrap()
    }
    return sum
}

fn solve2(data: &Vec<Vec<u32>>) -> u32 {
    let mut sum: u32 = 0;
    for row in data {
        let mut found = false;
        for i in 0..row.len() {
            for j in 0..row.len() {
                if i == j {
                    continue
                }
                if row[i] % row[j] == 0 {
                    sum += row[i] / row[j];
                    found = true;
                    break
                }
            }
            if found {
                break
            }
        }
    }
    return sum
}

fn main() {
    let file = fs::File::open("input").unwrap();
    let reader = io::BufReader::new(file);
    let mut data: Vec<Vec<u32>> = vec![];
    for line in reader.lines() {
        let row = line.unwrap().split("\t")
            .map(|s| s.parse().unwrap())
            .collect::<Vec<u32>>();
        data.push(row);
    }
    println!("{}", solve1(&data));
    println!("{}", solve2(&data));
}
