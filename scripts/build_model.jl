using DataFrames, CSV
using LinearAlgebra, Statistics
using ProgressMeter, CairoMakie, LaTeXStrings

include("../src/assembler.jl")
include("../src/generate_power_set.jl")
include("../src/import_test_functions.jl")
include("../src/export_figure.jl")

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

# Build and normalize the sample (zero mean and unitary standard deviation)
sample = hcat(flow_df, rainfall_df[:, 3:end])
X = (Float64.(Matrix(sample[:,2:end])) .- mean(Float64.(Matrix(sample[:,2:end])), dims=1))./std(Float64.(Matrix(sample[:,2:end])), dims=1)

# Split the sample in observations (x) and covariates (C)
x = X[:,1]
C = X[:,2:end]

# Extract the plausible covariates (C_tilde)
cov_idx = [5, 7, 9, 11, 13, 26]
C_tilde = C[:,cov_idx]

# Generate the power set of all possible combinations of plausible covariates
subsets = generate_power_set(size(C_tilde, 2))

# Import list of test functions
g_list = import_test_functions()

# Loop over the elements of the power set
subset_idx = 1
for subset in subsets
        # Generate the subset
        c = C_tilde[:, subset]

        # Loop over the elements in the subset
        c_name = ""
        for (n, e) in enumerate(subset)
                # Append covariate element to the string
                c_name = c_name*L"c_%$(e),"
        end

        # Loop over the test functions
        function_idx = 1
        for (label, g) in g_list
                # Compute μ = g(c)
                μ = g(c)

                # Create and format the figure
                title = L"\mu \in %$(label)(%$(c_name))"
                fig = Figure(; size = (600, 300))
                ax = Axis(fig[1, 1],
                          limits = (nothing, nothing, nothing, 1.5),
                          xgridvisible = false,
                          ygridvisible = false,
                          xlabel = L"\mu",
                          ylabel = L"X_t",
                          xlabelvisible = true,
                          ylabelvisible = true,
                          title = L"\mu \in %$(label)(%$(c_name))",
                          #xticks = [-1,0,1],
                          #yticks = [-0.35,0,0.5],
                          xticklabelsvisible = true,
                          yticklabelsvisible = true,
                          xtickalign = 1,
                          ytickalign = 1,
                         )

                # Plot the transformed data
                scatter!(ax, μ, x, color = (:blue,0.5), markersize=20)
                savefig("/model/$(subset_idx)_$(function_idx).png", fig)
                function_idx = function_idx + 1
        end
        global subset_idx = subset_idx + 1
end
