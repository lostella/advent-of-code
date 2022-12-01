function read_data(path)
    data = Array{Int64}[]
    open(path) do file
        chunk = Int64[]
        for line in readlines(file)
            if isempty(line)
                push!(data, chunk)
                chunk = Int64[]
            else
                push!(chunk, parse(Int64, line))
            end
        end
        push!(data, chunk)
    end
end

function solve1(data)
    maximum(map(sum, data))
end

function solve2(data)
    sum(sort(map(sum, data), rev=true)[1:3])
end

function main(path)
    data = read_data(path)
    println(solve1(data))
    println(solve2(data))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
