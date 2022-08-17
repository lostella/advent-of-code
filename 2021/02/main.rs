use std::fs;
use std::io::{self, prelude::*};

struct Submarine1 {
    x: i32,
    y: i32,
}

impl Submarine1 {
    fn execute_command(&mut self, command: &str) {
        let tokens = command.split_whitespace().collect::<Vec<&str>>();
        let qty = tokens.get(1).unwrap().parse::<i32>().unwrap();
        match *tokens.first().unwrap() {
            "up" => self.y -= qty,
            "down" => self.y += qty,
            "forward" => self.x += qty,
            _ => (),
        }
    }
}

fn solve1(lines: &Vec<String>) -> i32 {
    let mut submarine = Submarine1 { x: 0, y: 0 };
    for line in lines {
        submarine.execute_command(line);
    }
    submarine.x * submarine.y
}

struct Submarine2 {
    x: i32,
    y: i32,
    aim: i32,
}

impl Submarine2 {
    fn execute_command(&mut self, command: &str) {
        let tokens = command.split_whitespace().collect::<Vec<&str>>();
        let qty = tokens.get(1).unwrap().parse::<i32>().unwrap();
        match *tokens.first().unwrap() {
            "up" => self.aim -= qty,
            "down" => self.aim += qty,
            "forward" => {
                self.x += qty;
                self.y += self.aim * qty;
            }
            _ => (),
        }
    }
}

fn solve2(lines: &Vec<String>) -> i32 {
    let mut submarine = Submarine2 { x: 0, y: 0, aim: 0 };
    for line in lines {
        submarine.execute_command(line);
    }
    submarine.x * submarine.y
}

fn main() {
    let file = fs::File::open("input").unwrap();
    let reader = io::BufReader::new(file);
    let lines: Vec<String> = reader.lines().map(std::result::Result::unwrap).collect();

    println!("{}", solve1(&lines));
    println!("{}", solve2(&lines));
}
