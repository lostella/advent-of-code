import pathlib
from itertools import combinations

def smallest_two(l):
    return sorted(l)[:2]

def prod(iter):
    res = 1
    for el in iter:
        res *= el
    return res

def paper_needed(dims):
    return 2 * sum(map(prod, combinations(dims, 2))) + prod(smallest_two(dims))

def ribbon_needed(dims):
    return 2 * sum(smallest_two(dims)) + prod(dims)

def get_dims(line):
    return list(map(int, line.strip().split('x')))

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        print(sum(map(paper_needed, map(get_dims, fp))))
    with open(input_path) as fp:
        print(sum(map(ribbon_needed, map(get_dims, fp))))
