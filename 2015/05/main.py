def has_double(s):
    for a, b in zip(s[:-1], s[1:]):
        if a == b:
            return True
    return False

def count_vowels(s):
    return len([c for c in s if c in "aeiou"])

