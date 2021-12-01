import pathlib

moves_map = {
    "U": [1,2,3,1,2,3,4,5,6],
    "D": [4,5,6,7,8,9,7,8,9],
    "L": [1,1,2,4,4,5,7,7,8],
    "R": [2,3,3,5,6,6,8,9,9],
}

moves_map2 = {
    "U": [1,2,1,4,5,2,3,4,9,6,7,8,11],
    "D": [3,6,7,8,5,10,11,12,9,10,13,12,13],
    "L": [1,2,2,3,5,5,6,7,8,10,10,11,13],
    "R": [1,3,4,4,6,7,8,9,9,11,12,12,13],
}

def find_number(n, line, m=moves_map):
    for c in line:
        n = m[c][n-1]
    return n

def str_special(n):
    if n < 10:
        return str(n)
    return {
        10: "A",
        11: "B",
        12: "C",
        13: "D",
    }[n]

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        lines = list(map(lambda l: l.strip(), fp))
    code = []
    n = 5
    for l in lines:
        n = find_number(n, l)
        code.append(n)
    print("".join(str(n) for n in code))
    code2 = []
    n = 5
    for l in lines:
        n = find_number(n, l, m=moves_map2)
        code2.append(n)
    print("".join(str_special(n) for n in code2))
