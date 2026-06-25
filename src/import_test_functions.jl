using LaTeXStrings

# ------------------------------------------------------------
# Candidate test functions
# ------------------------------------------------------------

function g_affine(C::Matrix{Float64})
    n, k = size(C)
    β = ones(k) 
    return C * β
end

function g_quadratic(C::Matrix{Float64})
    n, k = size(C)

    p = zeros(n)

    # linear terms
    p .+= sum(C, dims=2)[:]

    # squared terms
    p .+= sum(C.^2, dims=2)[:]

    # pairwise interactions
    for i in 1:k-1
        for j in i+1:k
            p .+= C[:,i] .* C[:,j]
        end
    end

    return p
end

function g_cubic(C::Matrix{Float64})
    n, k = size(C)

    p = zeros(n)

    p .+= sum(C, dims=2)[:]
    p .+= sum(C.^2, dims=2)[:]
    p .+= sum(C.^3, dims=2)[:]

    for i in 1:k-1
        for j in i+1:k
            p .+= C[:,i] .* C[:,j]
        end
    end

    return p
end

function g_sigmoid_affine(C::Matrix{Float64})
    z = g_affine(C)
    return 1.0 ./ (1.0 .+ exp.(-z))
end

function g_tanh_affine(C::Matrix{Float64})
    return tanh.(g_affine(C))
end

function g_rbf(C::Matrix{Float64})
    μ = vec(mean(C, dims=1))
    d2 = sum((C .- μ').^2, dims=2)
    σ2 = mean(d2)
    return exp.(-d2[:] ./ (2σ2))
end

# Export the test functions as a dictionary
function import_test_functions()
        g_list = Dict(
                      "affine"         => g_affine,
                      L"\mathbb{P}_2"  => g_quadratic,
                      L"\mathbb{P}_3"  => g_cubic,
                      "sigmoidAffine"  => g_sigmoid_affine,
                      "tanhAffine"     => g_tanh_affine,
                      "rbf"            => g_rbf
                     )
        return g_list
end
