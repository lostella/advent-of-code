import pathlib
import re

double_symbol = r".*(.)\1.*"
three_vowels = r".*([aeiou].*){3,}"
forbidden_pair = r".*(ab|cd|pq|xy).*"
repeating_pair = r".*(..).*\1.*"
aba = r".*(.).\1.*"

def isnice1(s):
    if any(re.match(p, s) is None for p in [double_symbol, three_vowels]):
        return False
    if re.match(forbidden_pair, s):
        return False
    return True

def isnice2(s):
    if any(re.match(p, s) is None for p in [repeating_pair, aba]):
        return False
    return True

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        print(len(list(filter(isnice1, fp))))
    with open(input_path) as fp:
        print(len(list(filter(isnice2, fp))))
