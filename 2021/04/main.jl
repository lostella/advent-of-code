function string_to_matrix(T, str)
    lines = split(str, "\n")
    return vcat((parse.(T, split(line))' for line in lines)...)
end

initialize_board(m) = (m, zeros(Bool, size(m)...))

is_finished((m, c)) = any(all(c, dims=1)) || any(all(c, dims=2))

score((m, c), num) = is_finished((m, c)) ? sum(.!c .* m) * num : nothing

function update_board((m, c), num)
    idx = findfirst(isequal(num), m)
    if idx !== nothing
        c[idx] = true
    end
    return score((m, c), num)
end

function main(input_path)
    whole_input = join(eachline(input_path), "\n")
    split_input = split(whole_input, "\n\n")
    numbers = parse.(Int, split(split_input[1], ","))
    boards = [initialize_board(string_to_matrix(Int, str)) for str in split_input[2:end]]
    scores = Int[]
    for n in numbers
        for b in boards
            is_finished(b) && continue
            s = update_board(b, n)
            s !== nothing && push!(scores, s)
        end
    end
    println(scores[1])
    println(scores[end])
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
