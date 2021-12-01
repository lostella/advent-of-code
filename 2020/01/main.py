import pathlib
from math import prod

def find_two(data):
    seen = set()
    for n in data:
        if 2020-n in seen:
            return n, (2020-n)
        seen.add(n)

def find_three(data):
    seen = set()
    for n in data:
        for m in seen:
            if 2020-n-m in seen:
                return n, m, (2020-n-m)
        seen.add(n)

def main(input_path):
    with open(input_path) as fp:
        data = list(map(int, fp))
    print(prod(find_two(data)))
    print(prod(find_three(data)))
    
if __name__ == "__main__":
    main(pathlib.Path(__file__).parent.resolve() / "input")
