import pathlib

def move_forward(pos, dir, steps):
    return [tuple(p + s * d for p, d in zip(pos, dir)) for s in range(1, steps+1)]

turn_left = {
    (0, 1): (-1, 0),
    (-1, 0): (0, -1),
    (0, -1): (1, 0),
    (1, 0): (0, 1)
}

turn_right = {
    (0, 1): (1, 0),
    (1, 0): (0, -1),
    (0, -1): (-1, 0),
    (-1, 0): (0, 1)
}

def execute_command(pos, dir, s):
    t, steps = s[0], int(s[1:])
    if t == "L":
        dir = turn_left[dir]
    elif t == "R":
        dir = turn_right[dir]
    else:
        raise ValueError
    pos = move_forward(pos, dir, steps)
    return pos, dir

def l1norm(x):
    return sum(abs(xi) for xi in x)

def find_first_duplicate(l):
    seen = set()
    for el in l:
        if el in seen:
            return el
        seen.add(el)
    return None

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        for line in fp:
            commands = line.split(", ")
    pos = (0, 0)
    dir = (0, 1)
    path_all = [pos]
    for cmd in commands:
        path, dir = execute_command(pos, dir, cmd)
        path_all.extend(path)
        pos = path[-1]
    print(l1norm(pos))
    print(l1norm(find_first_duplicate(path_all)))
