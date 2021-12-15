using DataStructures

neighbors(idx::CartesianIndex{2}, A::AbstractMatrix) = filter(
    c -> all((1, 1) .<= Tuple(c) .<= size(A)),
    [idx + d for d in CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1)))]
)

function lowest_risk(A::AbstractMatrix, start::CartesianIndex{2}, finish::CartesianIndex{2})
    done = Set{CartesianIndex{2}}()
    queue = PriorityQueue{CartesianIndex{2}, eltype(A)}()
    queue[start] = 0
    while length(queue) > 0
        current, risk_current = dequeue_pair!(queue)
        current == finish && return risk_current
        push!(done, current)
        for n in neighbors(current, A)
            n in done && continue
            candidate_risk_n = risk_current + A[n]
            if !(n in keys(queue)) || candidate_risk_n < queue[n]
                queue[n] = candidate_risk_n
            end
        end
    end
end

increasing_replicas(A, n) = [(A .+ k) .|> v -> mod1(v, 9) for k in 0:n-1]

function main(input_path)
    data = hcat((eachline(input_path) |> collect .|> collect .|> x -> parse.(Int, x))...)'
    println(lowest_risk(data, CartesianIndex(1, 1), CartesianIndex(size(data)...)))
    data5 = hcat(increasing_replicas(data, 5)...)
    data55 = vcat(increasing_replicas(data5, 5)...)
    println(lowest_risk(data55, CartesianIndex(1, 1), CartesianIndex(size(data55)...)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
