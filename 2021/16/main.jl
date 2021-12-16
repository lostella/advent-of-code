hex2bits(s::String) = vcat((parse.(Int, collect(s), base=16) .|> (n -> digits(Bool, n, base=2, pad=4) |> reverse |> BitVector))...)
bits2int(bits) = foldl((s, b) -> 2 * s + b, bits)

struct Packet{type_id, P}
    version::Int
    payload::P
end

Packet(version, type_id, payload) = Packet{type_id, typeof(payload)}(version, payload)

version_sum(p::Packet{4}) = p.version
version_sum(p::Packet{type_id, <:Tuple}) where type_id = p.version + sum(version_sum.(p.payload))

function parse_value(bits)
    value_bits = Bool[]
    rest = bits
    while true
        block, rest = rest[1:5], rest[6:end]
        append!(value_bits, block[2:5])
        !block[1] && break
    end
    return bits2int(value_bits), rest
end

function parse_subpackets(bits)
    length_type_id = bits[1]
    subpackets = []
    rest = if length_type_id == 0
        subpackets_length = bits2int(bits[2:16])
        subpackets_bits = bits[16 .+ (1:subpackets_length)]
        while !isempty(subpackets_bits)
            new_subpacket, subpackets_bits = parse_packet(subpackets_bits)
            push!(subpackets, new_subpacket)
        end
        bits[16 + subpackets_length + 1:end]
    else
        number_subpackets = bits2int(bits[2:12])
        subpackets_bits = bits[12 + 1:end]
        for _ in 1:number_subpackets
            new_subpacket, subpackets_bits = parse_packet(subpackets_bits)
            push!(subpackets, new_subpacket)
        end
        subpackets_bits
    end
    return Tuple(subpackets), rest
end

function parse_packet(bits)
    version = bits2int(bits[1:3])
    type_id = bits2int(bits[4:6])
    payload, rest = (type_id == 4 ? parse_value : parse_subpackets)(bits[7:end])
    return Packet(version, type_id, payload), rest
end

parse_packet(hex::String) = parse_packet(hex2bits(hex))[1]

evaluate_packet(p::Packet{0}) = sum(evaluate_packet.(p.payload))
evaluate_packet(p::Packet{1}) = prod(evaluate_packet.(p.payload))
evaluate_packet(p::Packet{2}) = minimum(evaluate_packet.(p.payload))
evaluate_packet(p::Packet{3}) = maximum(evaluate_packet.(p.payload))
evaluate_packet(p::Packet{4}) = p.payload
evaluate_packet(p::Packet{5}) = evaluate_packet(p.payload[1]) > evaluate_packet(p.payload[2]) ? 1 : 0
evaluate_packet(p::Packet{6}) = evaluate_packet(p.payload[1]) < evaluate_packet(p.payload[2]) ? 1 : 0
evaluate_packet(p::Packet{7}) = evaluate_packet(p.payload[1]) == evaluate_packet(p.payload[2]) ? 1 : 0

function main(input_path)
    line = only(eachline(input_path))
    packet = parse_packet(line)
    println(version_sum(packet))
    println(evaluate_packet(packet))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
