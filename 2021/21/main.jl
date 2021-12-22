mutable struct DiceGame
    positions::Vector{Int}
    scores::Vector{Int}
    turn::Int
    roll_count::Int
end

DiceGame(pos1, pos2) = DiceGame([pos1, pos2], [0, 0], 1, 0)

function move!(game, roll1, roll2, roll3)
    steps = roll1 + roll2 + roll3
    game.positions[game.turn] = mod1(game.positions[game.turn] + steps, 10)
    game.scores[game.turn] += game.positions[game.turn]
    game.roll_count += 3
    game.turn = mod1(game.turn + 1, 2)
end

finished(game) = any(game.scores .>= 1000)

const possible_rolls = Dict(
    3 => 1,
    4 => 3,
    5 => 6,
    6 => 7,
    7 => 6,
    8 => 3,
    9 => 1,
)

function initial_count(pos1, pos2)
    u = zeros(Int, (10, 22, 10, 22))
    u[pos1, 1, pos2, 1] = 1
    return u
end

function evolve_count(u, turn)
    next_u = zero(u)
    for (r, c) in possible_rolls
        for p in 1:10
            next_p = mod1(p + r, 10)
            for s in 1:21
                if turn == 1
                    next_u[next_p, min(22, s + next_p), :, 1:21] += c * u[p, s, :, 1:21]
                else
                    next_u[:, 1:21, next_p, min(22, s + next_p)] += c * u[:, 1:21, p, s]
                end
            end
        end
    end
    return next_u
end

function count_wins(pos1, pos2)
    u = initial_count(pos1, pos2)
    wins = [0, 0]
    turn = 1
    while any(u .> 0)
        u = evolve_count(u, turn)
        wins += [sum(u[:, 22, :, :]), sum(u[:, :, :, 22])]
        turn = mod1(turn + 1, 2)
    end
    return wins[1], wins[2]
end

function main(input_path)
    lines = collect(eachline(input_path))
    pos1 = parse(Int, lines[1][length(lines[1])-1:end])
    pos2 = parse(Int, lines[2][length(lines[2])-1:end])
    game = DiceGame(pos1, pos2)
    k = 1
    while !finished(game)
        rolls = [mod1(k + i, 100) for i in 0:2]
        move!(game, rolls...)
        k = mod1(k + 3, 100)
    end
    println(minimum(game.scores) * game.roll_count)
    println(maximum(count_wins(pos1, pos2)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
