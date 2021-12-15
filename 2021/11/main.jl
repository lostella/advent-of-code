function lines_to_int_matrix(lines)
    return vcat((parse.(Int, collect(line))' for line in lines)...)
end

neighbors(idx::CartesianIndex{2}, A::AbstractMatrix) = filter(
    c -> all((1, 1) .<= Tuple(c) .<= size(A)),
    [idx + d for d in CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, 1), (1, -1), (-1, -1)))]
)

function evolve!(A)
    A .+= 1
    flashes = [idx for idx in CartesianIndices(A) if A[idx] == 10]
    count_flashes = 0
    while length(flashes) > 0
        f = popfirst!(flashes)
        count_flashes += 1
        for idx in neighbors(f, A)
            if A[idx] < 10
                A[idx] += 1
                A[idx] == 10 && push!(flashes, idx)
            end
        end
    end
    A .= mod.(A, 10)
    return count_flashes
end

function main(input_path)
    state = lines_to_int_matrix(eachline(input_path))
    println(sum(evolve!(state) for _ in 1:100))
    state = lines_to_int_matrix(eachline(input_path))
    count = 0
    while !all(iszero.(state))
        evolve!(state)
        count += 1
    end
    println(count)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
