add_to_dict!(d, p) = if !(p[1] in keys(d))
    d[p[1]] = [p[2]]
else
    push!(d[p[1]], p[2])
end

function adjacency_dict(pairs)
    d = Dict()
    for p in pairs
        add_to_dict!(d, p)
        add_to_dict!(d, reverse(p))
    end
    return d
end

is_big(s) = all(isuppercase.(collect(s)))
is_small(s) = all(islowercase.(collect(s))) && s != "start" && s != "end"
count_occurrences(a, c) = sum((el == a for el in c))

function extend(path, d, allowed)
    extended_paths = []
    if path[end] == "end"
        return []
    end
    for n in d[path[end]]
        if allowed(n, path)
            push!(extended_paths, push!(copy(path), n))
        end
    end
    return extended_paths
end

allowed_part1(n, path) = !(n in path) || is_big(n)
allowed_part2(n, path) = allowed_part1(n, path) || (is_small(n) && sum(count_occurrences(m, path) > 1 for m in path if is_small(m)) == 0)

function find_all_paths(d, allowed)
    paths = [["start"]]
    complete_paths = []
    while length(paths) > 0
        path = popfirst!(paths)
        if path[end] == "end"
            push!(complete_paths, path)
        end
        append!(paths, extend(path, d, allowed))
    end
    return complete_paths
end

function main(input_path)
    pairs = [tuple(string.(split(line, "-"))...) for line in eachline(input_path)]
    d = adjacency_dict(pairs)
    println(length(find_all_paths(d, allowed_part1)))
    println(length(find_all_paths(d, allowed_part2)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
