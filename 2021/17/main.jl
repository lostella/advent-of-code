function parse_input(line)
    mx = match(r"x=([-+]?\d+)..([-+]?\d+)", line)
    my = match(r"y=([-+]?\d+)..([-+]?\d+)", line)
    return parse.(Int, (mx.captures[1], mx.captures[2], my.captures[1], my.captures[2]))
end

triangular(n) = div(n * (n + 1), 2)

max_height(ymin, ymax) = if ymin <= 0 <= ymax
    error("the problem is unbounded")
    nothing
else
    triangular(max(abs(ymin)-1, abs(ymax)))
end

function simulate(vx, vy, xmin, xmax, ymin, ymax)
    px, py = 0, 0
    while true
        px += vx
        py += vy
        (xmin <= px <= xmax) && (ymin <= py <= ymax) && return (px, py)
        (py < ymin || px > xmax) && return nothing
        vx = sign(vx) * (abs(vx) - 1)
        vy -= 1
    end
end

function main(input_path)
    xmin, xmax, ymin, ymax = parse_input(only(eachline(input_path)))
    println(max_height(ymin, ymax))
    candidate_velocities = Iterators.product(sign(xmax)*(1:abs(xmax)), ymin:max(abs(ymin)-1, abs(ymax)))
    num_initial_velocities = sum(simulate(v..., xmin, xmax, ymin, ymax) !== nothing for v in candidate_velocities)
    println(num_initial_velocities)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
