using DataFrames, CairoMakie
using ProgressMeter

include("../src/flow_parser.jl")
include("../src/export_figure.jl")

# Import the file as a DataFrame
df = CSV.read("../data/flow/Flow_Min.csv", DataFrame)

# Loop over the number of sites
printstyled("Plotting and export the min flow timeseries at every site\n"; bold=true, underline=true, color=:light_blue)
@showprogress for n in 1:(ncol(df)-1)
        # Import data
        data = flow_parser(n+1)

        # Create and format the figure
        fig = Figure(; size = (1200, 600))
        ax = Axis(fig[1, 1],
                  xgridvisible = false,
                  ygridvisible = false,
                  xlabel = "date",
                  ylabel = "flow",
                  xlabelvisible = true,
                  ylabelvisible = true,
                  title = data.site*" (col. n.$(n+1))", 
                  #xticks = [-1,0,1],
                  #yticks = [-0.35,0,0.5],
                  xticklabelsvisible = true,
                  yticklabelsvisible = true,
                  xtickalign = 1,
                  ytickalign = 1,
                 )

        # Plot and export the timeseries 
        lines!(ax, data.data[:,1], data.data[:,2])
        savefig("flow_min/$(data.site).png", fig)
end
