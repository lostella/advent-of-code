import pathlib

def diff(data):
    return (b - a for a, b in zip(data,  data[1:]))

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        depths = list(map(lambda l: int(l.strip()), fp))
    print(sum(d > 0 for d in diff(depths)))
    depths3 = [sum(t) for t in zip(depths, depths[1:], depths[2:])]
    print(sum(d > 0 for d in diff(depths3)))
