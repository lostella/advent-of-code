use std::env;
use std::fs;
use std::convert::TryInto;

fn get_cell(lines: &Vec<Vec<char>>, i: i32, j: i32) -> char {
    if i < 0 || i >= lines.len().try_into().unwrap() {
        return '.'
    }
    if j < 0 || j >= lines[i as usize].len().try_into().unwrap() {
        return '.'
    }
    return lines[i as usize][j as usize]
}

fn count_neighbors(lines: &Vec<Vec<char>>, i: i32, j: i32) -> u8 {
    let mut c = 0;
    for ii in i-1..=i+1 {
        for jj in j-1..=j+1 {
            if ii == i && jj == j {
                continue
            }
            if get_cell(lines, ii, jj) != '.' {
                c += 1
            }
        }
    }
    c
}

fn main() {
    let path = env::current_exe().unwrap()
        .parent().unwrap()
        .join("input");

    let content = fs::read_to_string(path).unwrap();
    let mut lines = vec![];
    for line in content.lines() {
        lines.push(line.chars().collect::<Vec<_>>())
    }

    let mut count = 0;
    for i in 0..lines.len() {
        for j in 0..lines[i].len() {
            if lines[i][j] != '@' {
                continue
            }
            let c = count_neighbors(&lines, i as i32, j as i32);
            if c < 4 {
                count += 1
            }
        }
    }

    println!("{count}");

    let mut count = 0;
    loop {
        let mut to_remove = 0;
        for i in 0..lines.len() {
            for j in 0..lines[i].len() {
                if lines[i][j] != '@' {
                    continue
                }
                let c = count_neighbors(&lines, i as i32, j as i32);
                if c < 4 {
                    to_remove += 1;
                    lines[i][j] = 'x'
                }
            }
        }
        if to_remove == 0 {
            break
        }
        count += to_remove;
        for i in 0..lines.len() {
            for j in 0..lines[i].len() {
                if lines[i][j] == 'x' {
                    lines[i][j] = '.'
                }
            }
        }
    }

    println!("{count}")
}
