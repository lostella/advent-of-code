function rolling_sum(x, n)
    r = eltype(x)[]
    for k in 1:length(x)-n+1
        push!(r, sum(view(x, k:k+n-1)))
    end
    return r
end

function main(input_path)
    data = parse.(Int, eachline(input_path))
    println(sum(diff(data) .> 0))
    println(sum(diff(rolling_sum(data, 3)) .> 0))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
