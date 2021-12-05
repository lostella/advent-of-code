function to_binary_digit(c)
    (c == 'F' || c == 'L') && return 0
    (c == 'B' || c == 'R') && return 1
end

to_decimal(x) = foldl((s, b) -> 2 * s + b, x)

function main(input_path)
    ids = map(line -> to_decimal(to_binary_digit.(collect(line))), eachline(input_path))
    println(maximum(ids))
    all_possible_ids = 0:1023
    missing_ids = setdiff(all_possible_ids, ids)
    println(only(id for id in missing_ids if !(id-1 in missing_ids || id+1 in missing_ids)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
