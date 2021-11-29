import pathlib
from collections import defaultdict

def move(pos, m):
    if m == "v":
        return (pos[0], pos[1]-1)
    elif m == "^":
        return (pos[0], pos[1]+1)
    elif m == ">":
        return (pos[0]+1, pos[1])
    elif m == "<":
        return (pos[0]-1, pos[1])
    raise ValueError

def visit(pos, moves, count=None):
    if count is None:
        count = defaultdict(lambda: 0)
    count[pos] += 1
    for m in moves:
        pos = move(pos, m)
        count[pos] += 1
    return count

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        for line in fp:
            count = visit((0, 0), line.strip())
            print(len(count.items()))
            count = visit((0, 0), line.strip()[0::2])
            count = visit((0, 0), line.strip()[1::2], count=count)
            print(len(count.items()))
