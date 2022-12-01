function read_data(path)

end

function solve1(data)
    
end

function solve2(data)
    
end

function main(input_path)
    data = read_data(input_path)
    println(solve1(data))
    println(solve2(data))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
