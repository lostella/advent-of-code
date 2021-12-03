to_decimal(x) = foldl((s, b) -> 2 * s + b, x)

majority_bits(data) = round.(Int, sum(data) / length(data), Base.Rounding.RoundNearestTiesAway)

function main(input_path)
    data = [[c == '1' for c in line] for line in eachline(input_path)]
    m = majority_bits(data)
    println(to_decimal(m) * to_decimal(1 .- m))
    data1 = data
    for k in 1:length(data[1])
        m = majority_bits(data1)
        data1 = [d for d in data1 if d[k] == m[k]]
        length(data1) == 1 && break
    end
    data2 = data
    for k in 1:length(data[1])
        m = 1 .- majority_bits(data2)
        data2 = [d for d in data2 if d[k] == m[k]]
        length(data2) == 1 && break
    end
    println(to_decimal(only(data1)) * to_decimal(only(data2)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
