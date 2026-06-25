using DataFrames, CSV
using LinearAlgebra, Statistics
using ProgressMeter, CairoMakie

include("../src/assembler.jl")
include("../src/plot_distribution.jl")

# Build the observation matrices
observation_matrices = assembler()
flow_df = observation_matrices.flow_matrix
rainfall_df = observation_matrices.rainfall_matrix

# Extract the measurement dates
flow_dates = flow_df[!,(names(flow_df))[1]]
rainfall_dates = rainfall_df[!,(names(rainfall_df))[1]]

# Loop over the measurement dates
missing_idx = Integer[]
for (idx, date) in enumerate(rainfall_dates)
        # Check if the flow dates and the rainfall dates match
        if date ∈ flow_dates
                # Skip this step
        else
                push!(missing_idx, idx)
        end
end

# Remove the missing measurements from the rainfall data
deleteat!(rainfall_df, missing_idx)

# Build the sample
sample = hcat(flow_df, rainfall_df[:, 3:end])
CSV.write("../data/observations/sample.csv", sample)

# Normalize the sample (zero mean and unitary standard deviation)
X = (Float64.(Matrix(sample[:,2:end])) .- mean(Float64.(Matrix(sample[:,2:end])), dims=1))./std(Float64.(Matrix(sample[:,2:end])), dims=1)
CSV.write("../data/observations/standardized_sample.csv", DataFrame(X, :auto); header=false)

# Sanity check
for (idx, feature) in enumerate(eachcol(X))
        println("col.", idx, "    mean=", mean(feature), ", std=", std(feature))
end

# Compute the covariance matrix
Σ = cov(X) # (1/(size(X,2) - 1)).*(transpose(X)*X)
CSV.write("../data/observations/covariance.csv", DataFrame(Σ, :auto); header=false)

# Perform the eigendecomposition of the covariance matrix
decomposition = eigen(Σ)
Λ = decomposition.values
V = decomposition.vectors

# Plot the data distribution
plot_distribution(X)

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
