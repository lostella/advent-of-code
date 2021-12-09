function neighbors(idx::CartesianIndex{2}, A::AbstractMatrix)
    neighbors = CartesianIndex{2}[]
    idx[1] > 1 && push!(neighbors, CartesianIndex(idx[1]-1, idx[2]))
    idx[2] > 1 && push!(neighbors, CartesianIndex(idx[1], idx[2]-1))
    idx[1] < size(A,1) && push!(neighbors, CartesianIndex(idx[1]+1, idx[2]))
    idx[2] < size(A,2) && push!(neighbors, CartesianIndex(idx[1], idx[2]+1))
    return neighbors
end

function find_local_minima(A::AbstractArray{T,N}) where {T,N}
    local_minima = CartesianIndex{N}[]
    for idx in eachindex(A)
        if all(A[idx] < A[idx1] for idx1 in neighbors(idx, A))
            push!(local_minima, idx)
        end
    end
    return local_minima
end

function find_basin(idx::CartesianIndex{N}, A::AbstractArray{T,N}) where {T,N}
    basin = CartesianIndex{N}[]
    rest = [idx]
    while length(rest) > 0
        next = popfirst!(rest)
        if !(next in basin)
            push!(basin, next)
        end
        for loc in neighbors(next, A)
            if (A[loc] >= A[next]) && (A[loc] < 9) && !(loc in basin)
                push!(rest, loc)
            end
        end
    end
    return basin
end

function main(input_path)
    depth = hcat((parse.(Int, collect(line)) for line in eachline(input_path))...)'
    local_minima = find_local_minima(depth)
    println(sum([depth[idx]+1 for idx in local_minima]))
    basin_sizes = [length(find_basin(loc, depth)) for loc in local_minima]
    println(prod(sort(basin_sizes, rev=true)[1:3]))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
