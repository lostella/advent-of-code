function parse_insertion_rule(line)
    pair = string(line[1:2])
    insert = line[7]
    return pair => insert
end

function initialize_counter(coll)
    count = Dict{eltype(coll), Int}()
    for el in coll
        if !(el in keys(count))
            count[el] = 0
        end
        count[el] += 1
    end
    return count
end

function increase_counter!(d, k, v)
    if !(k in keys(d))
        d[k] = 0
    end
    d[k] += v
    return d
end

create_polymer(s) = (
    initialize_counter(s),
    initialize_counter(collect(join.(zip(s[1:end-1], s[2:end])))),
)

function grow_polymer!(polymer, rules)
    for (p, c) in collect(polymer[2])
        if p in keys(rules)
            n = rules[p]
            increase_counter!(polymer[1], n, c)
            increase_counter!(polymer[2], p, -c)
            increase_counter!(polymer[2], join((p[1], n)), c)
            increase_counter!(polymer[2], join((n, p[2])), c)
        end
    end
    return polymer
end

function main(input_path)
    lines = collect(eachline(input_path))
    polymer = create_polymer(lines[1])
    rules = Dict((parse_insertion_rule(line) for line in lines[3:end])...)
    for _ in 1:10
        grow_polymer!(polymer, rules)
    end
    println(maximum(values(polymer[1])) - minimum(values(polymer[1])))
    for _ in 1:30
        grow_polymer!(polymer, rules)
    end
    println(maximum(values(polymer[1])) - minimum(values(polymer[1])))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
