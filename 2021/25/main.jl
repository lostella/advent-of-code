char_to_int(c) = c == '.' ? 0 : (c == '>' ? 1 : 2)

function circshift_view(A::AbstractMatrix, (s1, s2))
    idx1 = 1:size(A, 1)
    idx2 = 1:size(A, 2)
    return view(A, circshift(idx1, s1), circshift(idx2, s2))
end

function move_towards!(A, dir::Symbol)
    v = (dir == :east ? 1 : 2)
    S = circshift_view(A, dir == :east ? (0, -1) : (-1, 0))
    to_move = [idx for idx in CartesianIndices(A) if A[idx] == v && S[idx] == 0]
    for idx in to_move
        A[idx] = 0
        S[idx] = v
    end
    return length(to_move)
end

function move!(A)
    num_moves = move_towards!(A, :east)
    num_moves += move_towards!(A, :south)
    return num_moves
end

function main(input_path)
    A = hcat((collect(map(char_to_int, collect(line))) for line in eachline(input_path))...)'
    k = 0
    while true
        num_moves = move!(A)
        k += 1
        num_moves == 0 && break
    end
    println(k)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
