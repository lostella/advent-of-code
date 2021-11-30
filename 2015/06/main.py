import pathlib
import re
from collections import defaultdict

def rectangle_points(tl, br):
    return ((x, y)
        for x in range(tl[0], br[0]+1)
        for y in range(tl[1], br[1]+1)
    )

def turnon(d, points):
    for p in points:
        d[p] = 1
    return d

def increase(d, points):
    for p in points:
        d[p] += 1
    return d

def turnoff(d, points):
    for p in points:
        d[p] = 0
    return d

def decrease(d, points):
    for p in points:
        d[p] = max(0, d[p]-1)
    return d

def toggle(d, points):
    for p in points:
        d[p] = (d[p] + 1) % 2
    return d

def increase2(d, points):
    for p in points:
        d[p] += 2
    return d

cmd_pattern = r"(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)"

def parsecmd(line):
    m = re.match(cmd_pattern, line)
    return m.group(1), (int(m.group(2)), int(m.group(3))), (int(m.group(4)), int(m.group(5)))

opmap = {
    "turn on": turnon,
    "turn off": turnoff,
    "toggle": toggle,
}

opmap2 = {
    "turn on": increase,
    "turn off": decrease,
    "toggle": increase2,
}

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        d = defaultdict(lambda: 0)
        for line in fp:
            op, tl, br = parsecmd(line)
            d = opmap[op](d, rectangle_points(tl, br))
        print(sum(d.values()))
    with open(input_path) as fp:
        d = defaultdict(lambda: 0)
        for line in fp:
            op, tl, br = parsecmd(line)
            d = opmap2[op](d, rectangle_points(tl, br))
        print(sum(d.values()))
