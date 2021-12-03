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

function main(input_path)
    all = join(eachline(input_path), "\n")
    ss = replace.(split(all, "\n\n"), "\n"=>" ")
    data = [
        Dict(key_value(p) for p in split(s))
        for s in ss
    ]
    println(sum(isvalid.(data)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
