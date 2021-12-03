function key_value(p)
    sp = split(p, ":")
    return sp[1]=>sp[2]
end

function isvalid(d)
    for k in ["iyr","byr","eyr","hgt","hcl","ecl","pid"]
        k in keys(d) || return false
    end
    return true
end

function isvalid2(d)
    !isvalid(d) && return false
    match(r"^\d{4}$", d["iyr"]) === nothing && return false
    iyr = parse(Int, d["iyr"])
    (iyr > 2020 || iyr < 2010) && return false
    match(r"^\d{4}$", d["byr"]) === nothing && return false
    byr = parse(Int, d["byr"])
    (byr > 2002 || byr < 1920) && return false
    match(r"^\d{4}$", d["eyr"]) === nothing && return false
    eyr = parse(Int, d["eyr"])
    (eyr > 2030 || eyr < 2020) && return false
    match(r"^\d+(cm|in)$", d["hgt"]) === nothing && return false
    hgt = parse(Int, d["hgt"][1:end-2])
    hgt_unit = d["hgt"][end-1:end]
    hgt_unit == "cm" && (hgt > 193 || hgt < 150) && return false
    hgt_unit == "in" && (hgt > 76 || hgt < 59) && return false
    match(r"^#[[:xdigit:]]{6}$", d["hcl"]) === nothing && return false
    match(r"^(amb|blu|brn|gry|grn|hzl|oth)$", d["ecl"]) === nothing && return false
    match(r"^\d{9}$", d["pid"]) === nothing && return false
    return true
end
  
function main(input_path)
    all = join(eachline(input_path), "\n")
    ss = replace.(split(all, "\n\n"), "\n"=>" ")
    data = [
        Dict(key_value(p) for p in split(s))
        for s in ss
    ]
    println(sum(isvalid.(data)))
    println(sum(isvalid2.(data)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
