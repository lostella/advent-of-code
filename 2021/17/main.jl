function parse_input(line)
    mx = match(r"x=([-+]?\d+)..([-+]?\d+)", line)
    my = match(r"y=([-+]?\d+)..([-+]?\d+)", line)
    return parse.(Int, (mx.captures[1], mx.captures[2], my.captures[1], my.captures[2]))
end

function max_height(ymin, ymax)
    @assert ymax < 0 "target is assumed to be in the negative y-semiaxis, got ymax=$(ymax)"
    return div(ymin * (ymin + 1), 2)
end

function velocity_ranges(xmin, xmax, ymin, ymax)
    @assert xmin >= 0 "target is assumed to be in the non-negative x-semiaxis, got xmin=$(xmin)"
    @assert ymax < 0 "target is assumed to be in the negative y-semiaxis, got ymax=$(ymax)"
    vxrange = round(Int, (sqrt(1 + 8 * xmin) - 1) / 2, RoundUp):xmax
    vyrange = ymin:(abs(ymin)-1)
    return vxrange, vyrange
end

function simulate(vx, vy, xmin, xmax, ymin, ymax)
    px, py = 0, 0
    while true
        px += vx
        py += vy
        (xmin <= px <= xmax) && (ymin <= py <= ymax) && return (px, py)
        (py < ymin || px > xmax) && return nothing
        vx = vx == 0 ? 0 : (vx > 0 ? vx - 1 : vx + 1)
        vy -= 1
    end
end

function count_velocities(xmin, xmax, ymin, ymax)
    vxrange, vyrange = velocity_ranges(xmin, xmax, ymin, ymax)
    candidate_velocities = Iterators.product(vxrange, vyrange)
    return sum(simulate(v..., xmin, xmax, ymin, ymax) !== nothing for v in candidate_velocities)
end

function main(input_path)
    xmin, xmax, ymin, ymax = parse_input(only(eachline(input_path)))
    println(max_height(ymin, ymax))
    println(count_velocities(xmin, xmax, ymin, ymax))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
