import pathlib

def read_data(path):
    pass

def solve1(data):
    pass

def solve2(data):
    pass

def main(path):
    data = read_data(path)
    print(solve1(data))
    print(solve2(data))

if __name__ == "__main__":
    main(pathlib.Path(__file__).parent.resolve() / "input")
