using LinearAlgebra

function parse_input(lines)
    data = []
    scanner_data = []
    for line in lines
        if isempty(line)
            push!(data, scanner_data)
            scanner_data = []
            continue
        end
        line[1:3] == "---" && continue
        coordinates = eval(Meta.parse("[" * line * "]"))
        push!(scanner_data, coordinates)
    end
    if !isempty(scanner_data)
        push!(data, scanner_data)
    end
    return data
end

pairwise_distances(points) = [norm(p - q) for p in points, q in points]

function find_common(A, B)
    matches = Tuple{Tuple{Int,Int},Tuple{Int,Int}}[]
    for i in 1:size(A, 1)
        for j in (i+1):size(A, 2)
            idx = findfirst(x -> isapprox(A[i, j], x), B)
            idx === nothing && continue
            push!(matches, ((i, j), Tuple(idx)))
        end
    end
    return matches
end

function push_to_dict!(d, k, v)
    if !(k in keys(d))
        d[k] = []
    end
    push!(d[k], v)
end

function add_to_dict!(d, k, v)
    if !(k in keys(d))
        d[k] = 0
    end
    d[k] += v
end

function count_frequencies(v::Vector{T}) where T
    counter = Dict{T, Int}()
    for el in v
        add_to_dict!(counter, el, 1)
    end
    return counter
end

most_common(v) = argmax(count_frequencies(v))

function find_correspondence(matches)
    isempty(matches) && return [[], []]
    d = Dict{Int, Vector{Int}}()
    for (a, b) in matches
        push_to_dict!(d, a[1], b[1])
        push_to_dict!(d, a[1], b[2])
        push_to_dict!(d, a[2], b[1])
        push_to_dict!(d, a[2], b[2])
    end
    return zip([(a, most_common(d[a])) for a in keys(d)]...) |> collect .|> collect
end

function rot3d(axis, theta)
    axis == :x && return [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)]
    axis == :y && return [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)]
    axis == :z && return [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1]
end

to_int(x) = round(Int, x)

const poses = let permute_axes = rot3d(:z, pi/2) * rot3d(:x, pi/2)
    gen = (
        [
            (rot3d(:x, theta) * rot3d(:z, rho)) .|> to_int,
            (rot3d(:y, theta) * rot3d(:x, rho) * permute_axes) .|> to_int,
            (rot3d(:z, theta) * rot3d(:y, rho) * permute_axes * permute_axes) .|> to_int,
        ]
        for rho in [0, pi] for theta in [0, pi/2, pi, 3pi/2]
    )
    vcat(gen...)
end

function merge(as, bs)
    dists_as, dists_bs = pairwise_distances.((as, bs))
    matches = find_common(dists_as, dists_bs)
    corr = find_correspondence(matches)
    (length(corr[1]) < 12) && return nothing
    as_common = as[corr[1]]
    bs_common = bs[corr[2]]
    for rot in poses
        pos_set = Dict()
        for (a, b) in zip(as_common, bs_common)
            pos = a - rot * b
            add_to_dict!(pos_set, pos, 1)
        end
        pos12 = findfirst(p -> p >= 12, pos_set)
        if !isnothing(pos12)
            return union(as, (b -> pos12 + rot * b).(bs)), pos12
        end
    end
    return nothing
end

function merge_all(data)
    merged = popfirst!(data)
    scanners = [[0, 0, 0]]
    while !isempty(data)
        found = false
        k = 1
        while k <= length(data)
            res = merge(merged, data[k])
            if res !== nothing
                merged, scanner = res
                push!(scanners, scanner)
                deleteat!(data, k)
                found = true
                break
            end
            k += 1
        end
        !found && break
    end
    return merged, scanners
end

function main(input_path)
    data = parse_input(eachline(input_path))
    merged, scanners = merge_all(data)
    println(length(merged))
    println(maximum(p -> norm(p[1] - p[2], 1), Iterators.product(scanners, scanners)) |> Int)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
