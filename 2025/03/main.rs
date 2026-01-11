use std::env;
use std::fs;

fn max_n_digits(s: &str, n: usize) -> Vec<char> {
    let mut digits = vec![];
    let mut cursor = 0;
    for k in 1..=n {
        let slc = &s[cursor..s.len() - n + k];
        let c = slc.chars().max().unwrap();
        let (pos, _) = slc.char_indices().find(|&(_, x)| x == c).unwrap();
        cursor = cursor + pos + 1;
        digits.push(c);
    }
    digits
}

fn main() {
    let path = env::current_exe().unwrap()
        .parent().unwrap()
        .join("input");

    let content = fs::read_to_string(path).unwrap();
    let mut lines = vec![];
    for line in content.lines() {
        lines.push(line)
    }

    let mut tot = 0;
    
    for line in &lines {
        let digits = max_n_digits(&line, 2);
        let new: u64 = digits.iter().collect::<String>().parse().unwrap();
        tot += new;
    }

    println!("{tot}");

    let mut tot = 0;

    for line in &lines {
        let digits = max_n_digits(&line, 12);
        let new: u64 = digits.iter().collect::<String>().parse().unwrap();
        tot += new;
    }

    println!("{}", tot.to_string());
}
