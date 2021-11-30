import pathlib

def pairs(s):
    return zip(s[:-1], s[1:])

def has_double(s):
    for a, b in pairs(s):
        if a == b:
            return True
    return False

def count_vowels(s):
    return len([c for c in s if c in "aeiou"])

def is_good(s):
    if not has_double(s):
        return False
    if count_vowels(s) < 3:
        return False
    forbidden_pairs = [
        ("a", "b"),
        ("c", "d"),
        ("p", "q"),
        ("x", "y"),
    ]
    if not set(pairs(s)).isdisjoint(forbidden_pairs):
        return False
    return True

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        print(len([line for line in fp if is_good(line.strip())]))
