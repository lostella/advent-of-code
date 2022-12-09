function to_range(s)
    range(map(s -> parse(Int, s), split(s, "-"))...)
end

function read_line(line)
    halves = split(line, ",")
    return collect(map(to_range, halves))
end

function read_data(path)
    return collect(map(read_line, readlines(path)))
end

function solve1(data)
    cnt = 0
    for pair in data
        common = intersect(pair[1], pair[2])
        if common == pair[1] || common == pair[2]
            cnt += 1
        end
    end
    return cnt
end

function solve2(data)
    cnt = 0
    for pair in data
        if !isempty(intersect(pair[1], pair[2]))
            cnt += 1
        end
    end
    return cnt
end

function main(input_path)
    data = read_data(input_path)
    println(solve1(data))
    println(solve2(data))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
