function decode(move)
    (move == "A" || move == "X") && return :rock
    (move == "B" || move == "Y") && return :paper
    (move == "C" || move == "Z") && return :scissors
end

function read_data(path)
    return [map(decode, split(line)) for line in readlines(path)]
end

const weaker_than = Dict(
    :paper => :rock,
    :rock => :scissors,
    :scissors => :paper,
)

const stronger_than = Dict(
    v => k for (k, v) in weaker_than
)

function score(move)
    move == :rock && return 1
    move == :paper && return 2
    move == :scissors && return 3
end

function score(opponent, us)
    s = if (opponent == weaker_than[us]) 
        6
    elseif (opponent == us)
        3
    else
        0
    end
    return s + score(us)
end

function solve1(data)
    return sum(score(pair...) for pair in data)
end

function true_score(opponent, us)
    s, move = if us == :rock # lose
        0, weaker_than[opponent]
    elseif us == :paper #draw
        3, opponent
    elseif us == :scissors # win
        6, stronger_than[opponent]
    end
    return s + score(move)
end

function solve2(data)
    return sum(true_score(pair...) for pair in data)
end

function main(input_path)
    data = read_data(input_path)
    println(solve1(data))
    println(solve2(data))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
