use std::env;
use std::fs;

fn main() {
    let path = env::current_exe()
        .expect("Error while getting executable path")
        .parent()
        .expect("Error while getting parent path")
        .join("input");

    let content = fs::read_to_string(path).expect("Error while reading file");

    let mut ranges = vec![];
    let mut ids = vec![];
    let mut ranges_done = false;

    for line in content.lines() {
        if line.trim() == "" {
            ranges_done = true;
            continue;
        }
        if !ranges_done {
            let ab: Vec<u64> = line.split("-").map(|s| s.parse::<u64>().unwrap()).collect();
            ranges.push((ab[0], ab[1]));
        } else {
            ids.push(line.parse::<u64>().unwrap());
        }
    }

    let mut count_fresh = 0;

    for id in ids {
        for r in &ranges {
            if r.0 <= id && id <= r.1 {
                count_fresh += 1;
                break;
            }
        }
    }

    println!("{count_fresh}");

    ranges.sort_by(|a, b| a.0.cmp(&b.0));

    let mut merged_ranges = vec![];
    let mut curr = ranges[0].clone();

    for r in ranges {
        if r.0 > r.1 {
            continue;
        }
        if r.0 > curr.1 + 1 {
            merged_ranges.push(curr);
            curr = r.clone();
        }
        if curr.1 <= r.1 {
            curr.1 = r.1
        }
    }
    merged_ranges.push(curr);

    let mut tot_size = 0;

    for r in merged_ranges {
        tot_size += r.1 - r.0 + 1
    }

    println!("{tot_size}");
}
