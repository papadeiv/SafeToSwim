using DataFrames, CSV
using LinearAlgebra, Statistics
using ProgressMeter, CairoMakie

include("../src/assembler.jl")

# Build the observation matrices
observation_matrices = assembler()
#=
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
=#

#=
using GLMakie
# Create and format the figure
fig = Figure(; size = (1200, 600))
ax = Axis(fig[1, 1],
          xgridvisible = false,
          ygridvisible = false,
          #xlabel = "date",
          #ylabel = "flow",
          xlabelvisible = true,
          ylabelvisible = true,
          #title = data.site, 
          #xticks = [-1,0,1],
          #yticks = [-0.35,0,0.5],
          xticklabelsvisible = true,
          yticklabelsvisible = true,
          xtickalign = 1,
          ytickalign = 1,
         )

# Plot ?????????? 
#lines!(ax, ???, ???)
fig
=#
