using Combinatorics 

function generate_power_set(m)
    cols = collect(1:m)

    subsets = Vector{Vector{Int}}()

    for r in 2:m
        append!(subsets, collect(combinations(cols, r)))
    end

    return subsets
end
