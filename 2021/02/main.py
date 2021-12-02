import pathlib

def parse(line):
    direction, steps = line.split(" ")
    return direction, int(steps)

def move(pos, direction, steps):
    if direction == "up":
        return (pos[0], pos[1] - steps)
    if direction == "down":
        return (pos[0], pos[1] + steps)
    if direction == "forward":
        return (pos[0] + steps, pos[1])
    raise ValueError

def move_with_aim(pos, direction, steps):
    if direction == "up":
        return (pos[0], pos[1], pos[2] - steps)
    if direction == "down":
        return (pos[0], pos[1], pos[2] + steps)
    if direction == "forward":
        return (pos[0] + steps, pos[1] + steps * pos[2], pos[2])
    raise ValueError

def main(input_path):
    with open(input_path) as fp:
        commands = list(map(parse, fp))
    pos = (0, 0)
    for cmd in commands:
        pos = move(pos, *cmd)
    print(pos[0] * pos[1])
    pos = (0, 0, 0)
    for cmd in commands:
        pos = move_with_aim(pos, *cmd)
    print(pos[0] * pos[1])

if __name__ == "__main__":
    main(pathlib.Path(__file__).parent.resolve() / "input")
