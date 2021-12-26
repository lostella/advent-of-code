struct AmphipodsBurrow{room_size}
    rooms::Dict{Char, Array{Char}}
    hallway::NTuple{7, Char}
end

const empty_location = '.'

AmphipodsBurrow(room_size::Int, rooms::Dict) = AmphipodsBurrow{room_size}(rooms, Tuple(empty_location for _ in 1:7))

function replace_at(t::NTuple{N, T}, k, v::T) where {N, T}
    return (t[1:k-1]..., v, t[k+1:end]...)
end

function move(burrow::AmphipodsBurrow{room_size}, m::Tuple{Char, Int}) where room_size
    rooms = deepcopy(burrow.rooms)
    p = pop!(rooms[m[1]])
    return AmphipodsBurrow{room_size}(rooms, replace_at(burrow.hallway, m[2], p))
end

function move(burrow::AmphipodsBurrow{room_size}, m::Tuple{Int, Char}) where room_size
    rooms = deepcopy(burrow.rooms)
    push!(rooms[m[2]], burrow.hallway[m[1]])
    return AmphipodsBurrow{room_size}(rooms, replace_at(burrow.hallway, m[1], empty_location))
end

function move(burrow::AmphipodsBurrow, moves::Vector{<:Tuple})
    b = burrow
    for m in moves
        legal = generate_moves(b)
        @assert m in legal "illegal move $m when at $b"
        b = move(b, m)
    end
    return b
end

project_to_hallway(h::Int) = h

function project_to_hallway(r::Char)
    r == 'A' && return 2.5
    r == 'B' && return 3.5
    r == 'C' && return 4.5
    return 5.5
end

function is_route_free(burrow::AmphipodsBurrow, from, to)
    hallway_from, hallway_to = project_to_hallway.((from, to))
    path = [k for k in 1:7 if k > min(hallway_from, hallway_to) && k < max(hallway_from, hallway_to)]
    return all(burrow.hallway[p] == empty_location for p in path)
end

is_room_full(burrow::AmphipodsBurrow{room_size}, r) where room_size = length(burrow.rooms[r]) == room_size
is_room_empty(burrow::AmphipodsBurrow, r) = isempty(burrow.rooms[r])

get_piece_at(burrow::AmphipodsBurrow, h::Int) = burrow.hallway[h]
get_piece_at(burrow::AmphipodsBurrow, r::Char) = burrow.rooms[r][end]

function can_move(burrow::AmphipodsBurrow, (from, to)::Tuple{Int, Char})
    piece_type = get_piece_at(burrow, from)
    piece_type == empty_location && return false
    (piece_type != to || any(burrow.rooms[to] .!= to)) && return false
    is_room_full(burrow, to) && return false
    !is_route_free(burrow, from, to) && return false
    return true
end

function can_move(burrow::AmphipodsBurrow, (from, to)::Tuple{Char, Int})
    is_room_empty(burrow, from) && return false
    get_piece_at(burrow, to) != empty_location && return false
    piece_type = get_piece_at(burrow, from)
    (piece_type == from) && !any(burrow.rooms[from] .!= from) && return false
    !is_route_free(burrow, from, to) && return false
    return true
end

function generate_moves(burrow::AmphipodsBurrow{room_size}) where room_size
    moves = Tuple[]
    for (h, r) in Iterators.product(1:7, ('A', 'B', 'C', 'D'))
        from, to = (burrow.hallway[h] == empty_location) ? (r, h) : (h, r)
        !can_move(burrow, (from, to)) && continue
        push!(moves, (from, to))
    end
    return moves
end

function is_finished(burrow::AmphipodsBurrow)
    any(burrow.hallway .!= empty_location) && return false
    for (k, room) in burrow.rooms
        any(room .!= k) && return false
    end
    return true
end

const _distance = [
    2  4  6  8; # 1
    1  3  5  7; # 2
    1  1  3  5; # 3
    3  1  1  3; # 4
    5  3  1  1; # 5
    7  5  3  1; # 6
    8  6  4  2; # 7
]#  A  B  C  D

distance(burrow::AmphipodsBurrow{room_size}, m::Tuple{Char, Int}) where room_size = _distance[m[2], m[1] - 'A' + 1] + (room_size - length(burrow.rooms[m[1]]) + 1)
distance(burrow::AmphipodsBurrow{room_size}, m::Tuple{Int, Char}) where room_size = _distance[m[1], m[2] - 'A' + 1] + (room_size - length(burrow.rooms[m[2]]))

const unit_cost = Dict(
    'A' => 1,
    'B' => 10,
    'C' => 100,
    'D' => 1000,
)

move_cost(burrow::AmphipodsBurrow, m::Tuple{Char, Int}) = unit_cost[get_piece_at(burrow, m[1])] * distance(burrow, m)
move_cost(burrow::AmphipodsBurrow, m::Tuple{Int, Char}) = unit_cost[get_piece_at(burrow, m[1])] * distance(burrow, m)

const base5enc = Dict(
    '.' => 0,
    'A' => 1,
    'B' => 2,
    'C' => 3,
    'D' => 4,
)

encode_as_int(v) = foldl((s, d) -> s * 5 + base5enc[d], v, init=0)

function encode_as_int(b::AmphipodsBurrow{room_size}) where room_size
    num = encode_as_int(b.hallway)
    num *= 5^room_size
    num += encode_as_int(b.rooms['A'])
    num *= 5^room_size
    num += encode_as_int(b.rooms['B'])
    num *= 5^room_size
    num += encode_as_int(b.rooms['C'])
    num *= 5^room_size
    num += encode_as_int(b.rooms['D'])
    return num
end

function search_best_sequence(burrow::AmphipodsBurrow, table::Dict=Dict{Int, Tuple{Int, <:Tuple}}())
    encoding = encode_as_int(burrow)
    if encoding in keys(table)
        return table[encoding]
    end

    is_finished(burrow) && return (0, ())
    moves = generate_moves(burrow)
    isempty(moves) && return (div(typemax(Int), 2), ())
    
    best_cost = typemax(Int)
    best_moves = nothing
    for m in moves
        seq_cost, seq_moves = search_best_sequence(move(burrow, m), table)
        m_cost = move_cost(burrow, m)
        if m_cost + seq_cost < best_cost
            best_cost = m_cost + seq_cost
            best_moves = (m, seq_moves...)
        end
    end
    table[encoding] = (best_cost, best_moves)
    return best_cost, best_moves
end

function load_input(input_path, room_size)
    lines = collect(eachline(input_path))
    rooms = Dict('A' => [], 'B' => [], 'C' => [], 'D' => [])
    for line in lines[4:-1:3]
        push!(rooms['A'], line[4])
        push!(rooms['B'], line[6])
        push!(rooms['C'], line[8])
        push!(rooms['D'], line[10])
    end
    return AmphipodsBurrow(room_size, rooms)
end

function main(input_path)
    burrow2 = load_input(input_path, 2)

    score, = search_best_sequence(burrow2)
    println(score)

    burrow4 = load_input(input_path, 4)

    insert!(burrow4.rooms['A'], 2, 'D')
    insert!(burrow4.rooms['A'], 3, 'D')
    insert!(burrow4.rooms['B'], 2, 'B')
    insert!(burrow4.rooms['B'], 3, 'C')
    insert!(burrow4.rooms['C'], 2, 'A')
    insert!(burrow4.rooms['C'], 3, 'B')
    insert!(burrow4.rooms['D'], 2, 'C')
    insert!(burrow4.rooms['D'], 3, 'A')

    score, = search_best_sequence(burrow4)
    println(score)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
