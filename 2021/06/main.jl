function evolve!(counters)
    new_fish = counters[1]
    counters[1:8] .= counters[2:9]
    counters[7] += new_fish
    counters[9] = new_fish
end

function main(input_path)
    initial_state = parse.(Int, split(only(eachline(input_path)), ","))
    counters = collect(sum(initial_state .== k) for k in 0:8)
    for _ in 1:80 evolve!(counters) end
    println(sum(counters))
    for _ in 81:256 evolve!(counters) end
    println(sum(counters))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
