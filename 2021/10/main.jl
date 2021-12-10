using Statistics

const matching_parenthesis = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')
const score_corrupted = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137, nothing => 0)
const score_completion = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)

function process_line(line)
    stack = []
    for c in line
        if c in keys(matching_parenthesis)
            push!(stack, c)
            continue
        end
        top = pop!(stack)
        if c == matching_parenthesis[top]
            continue
        else
            return c, []
        end
    end
    return nothing, stack
end

find_corrupted(line) = process_line(line)[1]
repair_incomplete(line) = reverse(map(c -> matching_parenthesis[c], process_line(line)[2]))

function main(input_path)
    println(sum(score_corrupted[find_corrupted(line)] for line in eachline(input_path)))
    all_scores = [foldl((s, c) -> 5 * s + score_completion[c], repair_incomplete(line); init=0) for line in eachline(input_path)]
    println(Int(median(s for s in all_scores if !iszero(s))))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
