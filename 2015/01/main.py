import pathlib
from itertools import accumulate

def to_increment(c):
    if c == '(':
        return 1
    elif c == ')':
        return -1
    raise ValueError

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        for line in fp:
            print(sum(map(to_increment, line.strip())))
            for idx, floor in enumerate(accumulate(map(to_increment, line.strip()))):
                if floor == -1:
                    print(idx+1)
                    break
            break
