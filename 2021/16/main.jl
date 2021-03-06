hex2bits(s::String) = vcat((parse.(Int, collect(s), base=16) .|> (n -> digits(Bool, n, base=2, pad=4) |> reverse |> BitVector))...)
bits2int(bits) = foldl((s, b) -> 2 * s + b, bits)

struct Packet{type_id, P}
    version::Int
    payload::P
end

Packet(version, type_id, payload) = Packet{type_id, typeof(payload)}(version, payload)

function parse_value(bits)
    value = 0
    k = 0
    while true
        stop = !bits[k+1]
        value = value * 16 + bits2int(bits[k+2:k+5])
        k += 5
        stop && break
    end
    return value, bits[k+1:end]
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

function parse_packet(hex::String)
    packet, rest = parse_packet(hex2bits(hex))
    @assert all(iszero.(rest))
    return packet
end

version_sum(p::Packet{4}) = p.version
version_sum(p::Packet{type_id, <:Tuple}) where type_id = p.version + sum(version_sum.(p.payload))

evaluate_packet(p::Packet{0}) = sum(evaluate_packet.(p.payload))
evaluate_packet(p::Packet{1}) = prod(evaluate_packet.(p.payload))
evaluate_packet(p::Packet{2}) = minimum(evaluate_packet.(p.payload))
evaluate_packet(p::Packet{3}) = maximum(evaluate_packet.(p.payload))
evaluate_packet(p::Packet{4}) = p.payload
evaluate_packet(p::Packet{5}) = >(evaluate_packet.(p.payload)...) |> Int
evaluate_packet(p::Packet{6}) = <(evaluate_packet.(p.payload)...) |> Int
evaluate_packet(p::Packet{7}) = ==(evaluate_packet.(p.payload)...) |> Int

function main(input_path)
    line = only(eachline(input_path))
    packet = parse_packet(line)
    println(version_sum(packet))
    println(evaluate_packet(packet))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
