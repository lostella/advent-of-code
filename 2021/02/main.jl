function parsecmd(line)
    words = split(line)
    return (words[1], parse(Int, words[2]))
end

function move(pos, direction, steps)
    direction == "up" && return (pos[1], pos[2] - steps)
    direction == "down" && return (pos[1], pos[2] + steps)
    direction == "forward" && return (pos[1] + steps, pos[2])
end

function move_with_aim(pos, direction, steps)
    direction == "up" && return (pos[1], pos[2], pos[3] - steps)
    direction == "down" && return (pos[1], pos[2], pos[3] + steps)
    direction == "forward" && return (pos[1] + steps, pos[2] + steps * pos[3], pos[3])
end

function main(input_path)
    commands = parsecmd.(eachline(input_path))
    pos = (0, 0)
    for cmd in commands
        pos = move(pos, cmd...)
    end
    println(pos[1] * pos[2])
    pos = (0, 0, 0)
    for cmd in commands
        pos = move_with_aim(pos, cmd...)
    end
    println(pos[1] * pos[2])
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
