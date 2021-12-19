struct SnailfishNumber
    numbers::Vector{Int}
    levels::Vector{Int}
    weights::Vector{Int}
end

function _push_to_snailfish_number!(a::SnailfishNumber, n::Int, l::Int, w::Int)
    push!(a.numbers, n)
    push!(a.levels, l)
    push!(a.weights, w)
    return a
end

function _push_to_snailfish_number!(a::SnailfishNumber, t, l::Int, w::Int)
    _push_to_snailfish_number!(a, t[1], l+1, 3*w)
    _push_to_snailfish_number!(a, t[2], l+1, 2*w)
end

SnailfishNumber(t) = _push_to_snailfish_number!(SnailfishNumber(Int[], Int[], Int[]), t, 0, 1)

function add(a::SnailfishNumber, b::SnailfishNumber)
    numbers = vcat(a.numbers, b.numbers)
    levels = 1 .+ vcat(a.levels, b.levels)
    weights = vcat(3 * a.weights, 2 * b.weights)
    return SnailfishNumber(numbers, levels, weights)
end

function maybe_explode!(a::SnailfishNumber)
    for k in 1:length(a.numbers)-1
        on_level_five = (a.levels[k] == a.levels[k+1] == 5)
        not_same_weight = (a.weights[k] != a.weights[k+1])
        if on_level_five && not_same_weight
            left = a.numbers[k]
            right = a.numbers[k+1]
            popat!(a.numbers, k+1)
            popat!(a.levels, k+1)
            popat!(a.weights, k+1)
            a.numbers[k] = 0
            a.levels[k] -= 1
            a.weights[k] /= 3
            if k > 1
                a.numbers[k-1] += left
            end
            if k < length(a.numbers)
                a.numbers[k+1] += right
            end
            return true
        end
    end
    return false
end

function maybe_split!(a::SnailfishNumber)
    T = eltype(a.numbers)
    for k in 1:length(a.numbers)
        if a.numbers[k] > 9
            left = round(T, a.numbers[k]/2, RoundDown)
            right = round(T, a.numbers[k]/2, RoundUp)
            insert!(a.numbers, k+1, right)
            insert!(a.levels, k+1, a.levels[k] + 1)
            insert!(a.weights, k+1, 2 * a.weights[k])
            a.numbers[k] = left
            a.levels[k] += 1
            a.weights[k] *= 3
            return true
        end
    end
    return false
end

function reduce!(a::SnailfishNumber)
    while true
        maybe_explode!(a) && continue
        maybe_split!(a) && continue
        break
    end
    return a
end

magnitude(a::SnailfishNumber) = sum(a.numbers .* a.weights)

function main(input_path)
    data = eachline(input_path) .|> s -> SnailfishNumber(eval(Meta.parse(s)))
    s = data[1]
    for a in data[2:end]
        s = reduce!(add(s, a))
    end
    println(magnitude(s))
    all_pairs = ((m, n) for m in data for n in data if m != n)
    println(maximum(p -> magnitude(reduce!(add(p...))), all_pairs))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
