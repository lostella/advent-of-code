import pathlib

def diff_open_close(s):
    res = 0
    for c in s:
        if c == '(':
            res += 1
        elif c == ')':
            res -= 1
        else:
            raise ValueError('unrecognized input character')
    return res

if __name__ == "__main__":
    input_path = pathlib.Path(__file__).parent.resolve() / "input"
    with open(input_path) as fp:
        for line in fp:
            print(diff_open_close(line.strip()))
            break
