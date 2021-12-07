using Statistics

function quadratic_fuel_cost(positions, target)
    steps = abs.(positions .- target)
    return sum(div.(steps .* (steps .+ 1), 2))
end

function main(input_path)
    positions = parse.(Int, split(only(eachline(input_path)), ","))
    optimal_position = Int(median(positions))
    println(sum(abs.(positions .- optimal_position)))
    mean_position = mean(positions)
    println(minimum(quadratic_fuel_cost(positions, t) for t in Int.([floor(mean_position), ceil(mean_position)])))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
