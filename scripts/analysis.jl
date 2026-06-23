using DataFrames, CSV
using LinearAlgebra, Statistics
using ProgressMeter, CairoMakie #, GLMakie

include("../src/assembler.jl")

# Build the observation matrices
observation_matrices = assembler()
flow_matrix = observation_matrices.flow_matrix
rainfall_matrix = observation_matrices.rainfall_matrix

# Build the sample
sample = hcat(flow_matrix[:, 2:end], rainfall_matrix[:, 2:end], makeunique=true)
CSV.write("../data/observations/sample.csv", sample)

# Compute the covariance matrix
X = Float64.(Matrix(sample))
Σ = transpose(X)*X

# Perform the eigendecomposition of the covariance matrix
decomposition = eigen(Σ)
Λ = decomposition.values
V = decomposition.vectors 
display(Λ)
