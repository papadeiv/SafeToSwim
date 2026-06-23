using DataFrames, CSV
using ProgressMeter, CairoMakie

include("../src/export_figure.jl")

# Loop over the observation matrices
printstyled("Plot and export the uncertainty ellipse\n"; bold=true, underline=true, color=:light_blue)
@showprogress for n in 2:7
        # Import the max flow data 
        filename = "observations/flow_max/$n.csv"
        df = CSV.read("../data/"*filename, DataFrame)

        # Define the data arrays
        dates_flow = df[!,(names(df))[1]]
        daily_flow = df[!,(names(df))[2]]
        max_past_days_flow = df[!,(names(df))[3]]
        tot_past_days_flow = df[!,(names(df))[4]]

        # Import the rainfall data 
        filename = "observations/rainfall/$n.csv"
        df = CSV.read("../data/"*filename, DataFrame)

        # Define the data arrays
        dates_rainfall = df[!,(names(df))[1]]
        daily_rainfall = df[!,(names(df))[2]]
        max_past_days_rainfall = df[!,(names(df))[3]]
        tot_past_days_rainfall = df[!,(names(df))[4]]

        # Create and format the figure
        fig = Figure(; size = (1800, 600))
        ax1 = Axis(fig[1, 1],
                   xgridvisible = false,
                   ygridvisible = false,
                   xlabel = "max flow",
                   ylabel = "rainfall",
                   xlabelvisible = true,
                   ylabelvisible = true,
                   title = "past 24 hours", 
                   #xticks = [-1,0,1],
                   #yticks = [-0.35,0,0.5],
                   xticklabelsvisible = true,
                   yticklabelsvisible = true,
                   xtickalign = 1,
                   ytickalign = 1,
                  )
        ax2 = Axis(fig[1, 2],
                   xgridvisible = false,
                   ygridvisible = false,
                   xlabel = "max flow",
                   ylabel = "rainfall",
                   xlabelvisible = true,
                   ylabelvisible = true,
                   title = "max over past $n days", 
                   #xticks = [-1,0,1],
                   #yticks = [-0.35,0,0.5],
                   xticklabelsvisible = true,
                   yticklabelsvisible = true,
                   xtickalign = 1,
                   ytickalign = 1,
                  )
        ax3 = Axis(fig[1, 3],
                   xgridvisible = false,
                   ygridvisible = false,
                   xlabel = "max flow",
                   ylabel = "rainfall",
                   xlabelvisible = true,
                   ylabelvisible = true,
                   title = "total over past $n days", 
                   #xticks = [-1,0,1],
                   #yticks = [-0.35,0,0.5],
                   xticklabelsvisible = true,
                   yticklabelsvisible = true,
                   xtickalign = 1,
                   ytickalign = 1,
                  )

        # Plot and export the scatterplot
        scatter!(ax1, daily_flow, daily_flow, color = (:blue,0.5), markersize = 20)
        scatter!(ax2, max_past_days_flow, max_past_days_flow, color = (:blue,0.5), markersize = 20)
        scatter!(ax3, tot_past_days_flow, tot_past_days_flow, color = (:blue,0.5), markersize = 20)
        savefig("uncertanity_ellipse/$n.png", fig)
end
