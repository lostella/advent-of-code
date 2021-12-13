function to_binary_matrix(pairs)
    A = zeros(Int, maximum(p -> p[2], pairs)+1, maximum(p -> p[1], pairs)+1)
    for p in pairs
        A[(reverse(p) .+ 1)...] = 1
    end
    return A
end

function fold_up(row, A)
    B = copy(A[1:row-1, :])
    overlap = A[end:-1:row+1, :]
    skip_rows = (row - 1) - size(overlap, 1)
    B[skip_rows + 1:end, :] .+= overlap
    return B
end

function fold_left(column, A)
    B = copy(A[:, 1:column-1])
    overlap = A[:, end:-1:column+1]
    skip_columns = (column - 1) - size(overlap, 2)
    B[:, skip_columns + 1:end] .+= overlap
    return B
end

function main(input_path)
    lines = collect(eachline(input_path))
    break_idx = findfirst(isempty, lines)
    pairs = [tuple(parse.(Int, split(line, ','))...) for line in lines[1:break_idx-1]]
    A = to_binary_matrix(pairs)
    folds = [(line[12] == 'x' ? :left : :up, parse(Int, line[14:end])) for line in lines[break_idx+1:end]]
    transformations = [f[1] == :left ? a -> fold_left(f[2]+1, a) : a -> fold_up(f[2]+1, a) for f in folds]
    println(sum(transformations[1](A) .> 0))
    for t in transformations
        A = t(A)
    end
    for row in eachrow(A)
        println(join(row .|> el -> el > 0 ? "#" : " "))
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
