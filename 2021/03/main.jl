function todecimal(x)
    s = 0
    for b in x
        s = 2 * s + b
    end
    return s
end

majority_bits(data) = begin
    _round(T, x) = x == 0.5 ? T(1) : round(T, x)
    _round.(Int, sum(data) / length(data))
end

function main(input_path)
    data = [[c == '1' for c in line] for line in eachline(input_path)]
    m = majority_bits(data)
    println(todecimal(m) * todecimal(1 .- m))
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
    println(todecimal(only(data1)) * todecimal(only(data2)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
