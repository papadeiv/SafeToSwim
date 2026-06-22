using GLMakie
include("../src/flow_parser.jl")

# Import data
data = flow_parser(2)

# Create and format the figure
fig = Figure(; size = (1200, 600))
ax = Axis(fig[1, 1],
          xgridvisible = false,
          ygridvisible = false,
          xlabel = "date",
          ylabel = "flow",
          xlabelvisible = true,
          ylabelvisible = true,
          title = data.site, 
          #xticks = [-1,0,1],
          #yticks = [-0.35,0,0.5],
          xticklabelsvisible = true,
          yticklabelsvisible = true,
          xtickalign = 1,
          ytickalign = 1,
         )

# Plot the timeseries 
lines!(ax, data.data[:,1], data.data[:,2])
fig
