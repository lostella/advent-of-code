import pathlib

def diff(data, lag=1):
    return (b - a for a, b in zip(data,  data[lag:]))

def main(input_path):
    with open(input_path) as fp:
        depths = list(map(int, fp))
    print(sum(d > 0 for d in diff(depths)))
    print(sum(d > 0 for d in diff(depths, lag=3)))

if __name__ == "__main__":
    main(pathlib.Path(__file__).parent.resolve() / "input")
