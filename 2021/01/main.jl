function main(input_path)
    data = parse.(Int, eachline(input_path))
    println(sum(diff(data) .> 0))
    @views println(sum(data[4:end] - data[1:end-3] .> 0))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
