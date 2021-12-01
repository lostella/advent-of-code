import pathlib
import re

def valid_triangle(t):
    return (
        t[0]+t[1] > t[2] and
        t[1]+t[2] > t[0] and
        t[0]+t[2] > t[1]
    )

def triple(line):
    m = re.match("\s*(\d+)\s+(\d+)\s+(\d+)", line)
    if m is None:
        print(line)
    return tuple(int(m.group(k)) for k in range(1,4))

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        triples = list(map(triple, fp))
    print(sum(valid_triangle(t) for t in triples))
    columns = list(zip(*triples))
    newtriples = [
        tuple(c[i:i+3]) for c in columns for i in range(0, len(c), 3)
    ]
    print(sum(valid_triangle(t) for t in newtriples))
    