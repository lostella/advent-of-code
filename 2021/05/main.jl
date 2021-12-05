function parse_segment(line)
    m = match(r"^(\d+),(\d+) -> (\d+),(\d+)$", line)
    return (parse(Int, m.captures[1]), parse(Int, m.captures[2])), (parse(Int, m.captures[3]), parse(Int, m.captures[4]))
end

is_horizontal(((x1, y1), (x2, y2))) = y1 == y2
is_vertical(((x1, y1), (x2, y2))) = x1 == x2
is_diagonal(((x1, y1), (x2, y2))) = abs(x1 - x2) == abs(y1 - y2)
_sign(a) = iszero(a) ? 1 : sign(a)
segment_points(((x1, y1), (x2, y2))) = tuple.(x1:_sign(x2-x1):x2, y1:_sign(y2-y1):y2)

function map_vents(segments)
    m = Dict()
    for s in segments
        for p in segment_points(s)
            p in keys(m) ? m[p] += 1 : m[p] = 1
        end
    end
    return m
end

function main(input_path)
    pairs = [parse_segment(line) for line in eachline(input_path)]
    horizontal_vertical = filter(p -> is_horizontal(p) || is_vertical(p), pairs)
    vents = map_vents(horizontal_vertical)
    println(sum(v > 1 for v in values(vents)))
    horizontal_vertical_diagonal = filter(p -> is_horizontal(p) || is_vertical(p) || is_diagonal(p), pairs)
    vents = map_vents(horizontal_vertical_diagonal)
    println(sum(v > 1 for v in values(vents)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
