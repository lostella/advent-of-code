patch_3_by_3(idx::CartesianIndex{2}) = [idx + d for d in CartesianIndex.(((-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 0), (0, 1), (1, -1), (1, 0), (1, 1)))]

sub_bits_to_int(bits, idxs, default) = foldl((s, idx) -> 2 * s + (idx in CartesianIndices(bits) ? bits[idx] : default), idxs, init=0)

function enhance((image_bits, padding), program_bits)
    padded_bits = fill(padding, size(image_bits) .+ 2)
    padded_bits[2:size(image_bits, 1) + 1, 2:size(image_bits, 2) + 1] = image_bits
    enhanced_bits = copy(padded_bits)
    for idx in CartesianIndices(enhanced_bits)
        enhanced_bits[idx] = program_bits[1 + sub_bits_to_int(padded_bits, patch_3_by_3(idx), padding)]
    end
    return enhanced_bits, padding == 1 ? program_bits[512] : program_bits[1]
end

function main(input_path)
    lines = collect(eachline(input_path))
    program_bits = collect(lines[1]) .|> (c -> c == '#' ? true : false)
    image_bits = hcat((collect(image_line) .|> (c -> c == '#' ? true : false) for image_line in lines[3:end])...)'
    padding = 0
    for _ in 1:2
        image_bits, padding = enhance((image_bits, padding), program_bits)
    end
    @assert padding == 0
    println(sum(image_bits))
    padding = 0
    for _ in 1:48
        image_bits, padding = enhance((image_bits, padding), program_bits)
    end
    @assert padding == 0
    println(sum(image_bits))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
