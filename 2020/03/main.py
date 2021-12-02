import pathlib
from math import prod

def descend(rows, right, down):
    nrows, ncols = len(rows), len(rows[0])
    i, j = 0, 0
    while i < nrows:
        yield rows[i][j]
        j = (j + right) % ncols
        i += down

def main(input_path):
    with open(input_path) as fp:
        rows = list(map(lambda l: l.strip(), fp))
    print(sum(p == "#" for p in descend(rows, right=3, down=1)))
    directions = [(1,1),(3,1),(5,1),(7,1),(1,2)]
    print(prod(sum(p == "#" for p in descend(rows, *dir)) for dir in directions))

if __name__ == "__main__":
    main(pathlib.Path(__file__).parent.resolve() / "input")
