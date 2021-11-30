import hashlib

def mine_adventcoin(key, prefix):
    idx = 1
    key_encoded = key.encode()
    while True:
        m = hashlib.md5(key_encoded)
        m.update(str(idx).encode())
        if m.hexdigest().startswith(prefix):
            return idx
        idx += 1

def mine_adventcoin5(key):
    return mine_adventcoin(key, prefix="0"*5)

def mine_adventcoin6(key):
    return mine_adventcoin(key, prefix="0"*6)

if __name__ == "__main__":
    print(mine_adventcoin5("iwrupvqb"))
    print(mine_adventcoin6("iwrupvqb"))
