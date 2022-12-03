function read_data(path)
    return collect(readlines(path))
end

split2(s::String) = (s[1:Int(length(s)//2)], s[Int(length(s)//2) + 1:end])

function score(c)
    if 'a' <= c <= 'z'
        return c - 'a' + 1
    end
    return c - 'A' + 27
end

function solve1(data)
    pairs = map(split2, data)
    return sum(score(intersect(pair...)[1]) for pair in pairs)
end

function solve2(data)
    triples = [data[i:i+2] for i in 1:3:length(data)]
    return sum(score(intersect(triple...)[1]) for triple in triples)
end

function main(input_path)
    data = read_data(input_path)
    println(solve1(data))
    println(solve2(data))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
