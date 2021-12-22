const Segment = UnitRange{Int}

contained(a::Segment, b::Segment) = (b[1] <= a[1] <= b[end]) && (b[1] <= a[end] <= b[end])
disjoint(a::Segment, b::Segment) = (b[1] > a[end]) || (b[end] < a[1])

function split_overlap(a::Segment, b::Segment)
    (disjoint(a, b) || contained(a, b)) && return [a]
    if a[1] < b[1] && b[end] < a[end]
        return [a[1]:(b[1] - 1), b, (b[end] + 1):a[end]]
    end
    if a[1] < b[1]
        return [a[1]:(b[1] - 1), b[1]:a[end]]
    end
    return [a[1]:b[end], (b[end] + 1):a[end]]
end

struct Cube
    x::Segment
    y::Segment
    z::Segment
end

contained(a::Cube, b::Cube) = contained(a.x, b.x) && contained(a.y, b.y) && contained(a.z, b.z)
disjoint(a::Cube, b::Cube) = disjoint(a.x, b.x) || disjoint(a.y, b.y) || disjoint(a.z, b.z)
volume(a::Cube) = length(a.x) * length(a.y) * length(a.z)

function split_overlap(a::Cube, b::Cube)
    (disjoint(a, b) || contained(a, b)) && return [a]
    xs = split_overlap(a.x, b.x)
    ys = split_overlap(a.y, b.y)
    zs = split_overlap(a.z, b.z)
    return [Cube(x, y, z) for (x, y, z) in Iterators.product(xs, ys, zs)]
end

function parse_line(line)
    m = match(r"(on|off) x=([-+]?\d+)..([-+]?\d+),y=([-+]?\d+)..([-+]?\d+),z=([-+]?\d+)..([-+]?\d+)", line)
    xmin, xmax, ymin, ymax, zmin, zmax = parse.(Int, m.captures[2:7])
    value = m.captures[1] == "on" ? 1 : 0
    return value, Cube(xmin:xmax, ymin:ymax, zmin:zmax)
end

function turn_off(on_already, cube)
    on_after = Cube[]
    while !isempty(on_already)
        o = popfirst!(on_already)
        if disjoint(o, cube)
            push!(on_after, o)
        else
            o_splits = split_overlap(o, cube)
            for s in o_splits
                if disjoint(s, cube)
                    push!(on_after, s)
                end
            end
        end
    end
    return on_after
end

function turn_on(on_already, cube)
    # have you tried turning it off and on again?
    on_already = turn_off(on_already, cube)
    push!(on_already, cube)
    return on_already
end

function main(input_path)
    all_instructions = parse_line.(eachline(input_path))
    small_instructions = [(v, c) for (v, c) in all_instructions if contained(c, Cube(-50:50, -50:50, -50:50))]
    
    on_cubes = []
    for (value, cube) in small_instructions
        if value == 0
            on_cubes = turn_off(on_cubes, cube)
        else
            on_cubes = turn_on(on_cubes, cube)
        end
    end
    println(sum(volume.(on_cubes)))

    on_cubes = []
    for (value, cube) in all_instructions
        if value == 0
            on_cubes = turn_off(on_cubes, cube)
        else
            on_cubes = turn_on(on_cubes, cube)
        end
    end
    println(sum(volume.(on_cubes)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
