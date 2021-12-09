using Random

function parse_line(line)
    patterns_output = split(line, " | ")
    return split.(patterns_output)
end

sort_string(s::String) = s |> collect |> sort |> join
shuffle_string(s::String) = join(shuffle!(collect(s)))

const standard_mapping = Dict(
    "abcefg" => 0,
    "cf" => 1,
    "acdeg" => 2,
    "acdfg" => 3,
    "bcdf" => 4,
    "abdfg" => 5,
    "abdefg" => 6,
    "acf" => 7,
    "abcdefg" => 8,
    "abcdfg" => 9,
)

rewire_pattern(d::Dict, s) = sort_string(replace(s, d...))
rewire_pattern(d::Dict) = s -> rewire_pattern(d, s)

digits_to_number(v) = foldl((s, d) -> 10 * s + d, v)

function find_permutation(ss)
    natural_order = "abcdefg"
    while true
        permuted_order = shuffle_string(natural_order)
        d = Dict(p => n for (p, n) in zip(permuted_order, natural_order))
        correct = 0
        for s in ss
            rewired_s = rewire_pattern(d, s)
            !(rewired_s in keys(standard_mapping)) && break
            correct += 1
        end
        correct == length(ss) && return d
    end
end

function main(input_path)
    data = parse_line.(eachline(input_path))
    println(sum(
        entry -> sum(entry[2] .|> length .|> in([2, 3, 4, 7])),
        data
    ))
    println(sum(
        entry -> entry[2] .|> rewire_pattern(find_permutation(entry[1])) .|> s -> standard_mapping[s] |> digits_to_number,
        data
    ))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
