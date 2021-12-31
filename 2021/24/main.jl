add(a, b) = a + b
mul(a, b) = a * b
eql(a, b) = 1 * (a == b)
# div is in Base
# mod is in Base

parse_instruction(line) = line |> split .|> Meta.parse |> Tuple

function break_instructions(instructions::Vector)
    count_block = 1
    count_inp = 0
    blocks = Vector[]
    block = Any[]
    for instruction in instructions
        if instruction[1] == :inp
            count_inp += 1
            if count_inp > count_block
                push!(blocks, block)
                count_block += 1
                block = Any[instruction]
            else
                push!(block, instruction)
            end
        else
            push!(block, instruction)
        end
    end
    push!(blocks, block)
    return blocks
end

mutable struct MONADState
    w::Int
    x::Int
    y::Int
    z::Int
end

MONADState() = MONADState(0, 0, 0, 0)
MONADState(s::MONADState) = MONADState(s.w, s.x, s.y, s.z)

getvalue(::MONADState, x::Int) = x
getvalue(s::MONADState, x::Symbol) = getfield(s, x)

function execute((_, register)::Tuple{Symbol, Symbol}, state::MONADState, inp::Int)
    new_state = MONADState(state)
    setfield!(new_state, register, inp)
    return new_state
end

function execute((instruction, register, operand)::Tuple{Symbol, Symbol, O}, state::MONADState, inp::Int) where {O <: Union{Int, Symbol}}
    new_state = MONADState(state)
    fn = getfield(Main, instruction)
    output = fn(getvalue(new_state, register), getvalue(new_state, operand))
    setfield!(new_state, register, output)
    return new_state
end

function execute(instructions::Vector, state::MONADState, inp::Int)
    last_state = state
    for instruction in instructions
        last_state = execute(instruction, last_state, inp)
    end
    return last_state
end

function search_zero_preimage(blocks, state::MONADState, digits_set, table=Dict())
    k = (length(blocks), state.w, state.x, state.y, state.z)
    k in keys(table) && return table[k]
    if isempty(blocks)
        state.z == 0 && return ()
        return nothing
    end
    for d in digits_set
        new_state = execute(first(blocks), state, d)
        subseq = search_zero_preimage(Iterators.drop(blocks, 1), new_state, digits_set, table)
        if subseq !== nothing
            seq = (d, subseq...)
            table[k] = seq
            return seq
        else
            table[k] = nothing
        end
    end
    return nothing
end

function main(input_path)
    instructions = eachline(input_path) .|> parse_instruction
    blocks = break_instructions(instructions)
    digits = search_zero_preimage(blocks, MONADState(), 9:-1:1)
    println(join(string.(digits)))
    digits = search_zero_preimage(blocks, MONADState(), 1:9)
    println(join(string.(digits)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
