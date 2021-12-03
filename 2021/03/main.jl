to_decimal(x) = foldl((s, b) -> 2 * s + b, x)

majority_bits(data) = round.(Int, sum(data) / length(data), Base.Rounding.RoundNearestTiesAway)

function filter_data(data, criterion)
    for k in 1:length(data[1])
        m = criterion(data)
        data = [d for d in data if d[k] == m[k]]
        length(data) == 1 && break
    end
    return data
end

function main(input_path)
    data = [[c == '1' for c in line] for line in eachline(input_path)]
    m = majority_bits(data)
    println(to_decimal(m) * to_decimal(1 .- m))
    data1 = filter_data(data, d -> majority_bits(d))
    data2 = filter_data(data, d -> 1 .- majority_bits(d))
    println(to_decimal(only(data1)) * to_decimal(only(data2)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
