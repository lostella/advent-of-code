import pathlib
import re

def parse(line):
    m = re.match("(\d+)-(\d+) (.): (.*)", line)
    return int(m.group(1)), int(m.group(2)), m.group(3), m.group(4)

def check(min, max, char, passwd):
    return min <= sum(p == char for p in passwd) <= max

def check2(p1, p2, char, passwd):
    return (passwd[p1-1] == char) != (passwd[p2-1] == char)

def main(input_path):
    with open(input_path) as fp:
        lines = list(fp)
    print(sum(check(*parse(l)) for l in lines))
    print(sum(check2(*parse(l)) for l in lines))  

if __name__ == "__main__":
    main(pathlib.Path(__file__).parent.resolve() / "input")
    