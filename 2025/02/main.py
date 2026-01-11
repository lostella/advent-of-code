from pathlib import Path

with open(Path(__file__).parent / "input") as fp:
    data = fp.readlines()[0]

def is_fake(num: int):
    s = str(num)
    if len(s) % 2 != 0:
        return False
    return s[:len(s)//2] == s[len(s)//2:]

def is_fake_2(num: int):
    s = str(num)
    divisors = [k for k in range(1, len(s)) if len(s) % k == 0]
    for d in reversed(divisors):
        found = True
        for k in range(len(s) // d - 1):
            if s[k*d:(k+1)*d] != s[(k+1)*d:(k+2)*d]:
                found = False
                break
        if found:
            return True
    return False
            

intervals = data.split(",")
tot = 0
tot2 = 0
for interval in intervals:
    a, b = interval.split("-")
    for n in range(int(a),int(b)+1):
        if is_fake(n):
            tot += n
        if is_fake_2(n):
            tot2 += n

print(tot)
print(tot2)
