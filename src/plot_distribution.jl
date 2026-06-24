using CairoMakie 

include("../src/export_figure.jl")

function plot_distribution(sample)
        # Decouple the observations (E.coli) from the data (x) 
        y = sample[:,1]
        X = sample[:,2:end]

        # Define the titles and labels
        labels = ["Max flow",
                  "Max flow",
                  "Total flow",
                  "Max flow",
                  "Total flow",
                  "Max flow",
                  "Total flow",
                  "Max flow",
                  "Total flow",
                  "Max flow",
                  "Total flow",
                  "Max flow",
                  "Total flow",
                  "Max rainfall",
                  "Max rainfall",
                  "Total rainfall",
                  "Max rainfall",
                  "Total rainfall",
                  "Max rainfall",
                  "Total rainfall",
                  "Max rainfall",
                  "Total rainfall",
                  "Max rainfall",
                  "Total rainfall",
                  "Max rainfall",
                  "Total rainfall"]
         titles = ["past 24 hours",
                   "past 48 hours",
                   "past 48 hours",
                   "past 72 hours",
                   "past 72 hours",
                   "past 96 hours",
                   "past 96 hours",
                   "past 120 hours",
                   "past 120 hours",
                   "past 144 hours",
                   "past 144 hours",
                   "past 168 hours",
                   "past 168 hours",
                   "past 24 hours",
                   "past 48 hours",
                   "past 48 hours",
                   "past 72 hours",
                   "past 72 hours",
                   "past 96 hours",
                   "past 96 hours",
                   "past 120 hours",
                   "past 120 hours",
                   "past 144 hours",
                   "past 144 hours",
                   "past 168 hours",
                   "past 168 hours"]

        # Loop over the columns of the data in groups of 3 (non-overlapping)
        n = size(X,2)
        plt_idx = 1
        for idx in 1:3:n 
                # Create and format the figure
                fig = Figure(; size = (1800, 600))
                ax1 = Axis(fig[1, 1],
                           xgridvisible = false,
                           ygridvisible = false,
                           xlabel = labels[idx],
                           ylabel = "E.coli",
                           xlabelvisible = true,
                           ylabelvisible = true,
                           title = titles[idx], 
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
                           xlabel = labels[idx+1],
                           xlabelvisible = true,
                           ylabelvisible = true,
                           title = titles[idx+1], 
                           #xticks = [-1,0,1],
                           #yticks = [-0.35,0,0.5],
                           xticklabelsvisible = true,
                           yticklabelsvisible = false,
                           xtickalign = 1,
                           ytickalign = 1,
                          )
                ax3 = Axis(fig[1, 3],
                           xgridvisible = false,
                           ygridvisible = false,
                           xlabelvisible = true,
                           ylabelvisible = false,
                           #xticks = [-1,0,1],
                           #yticks = [-0.35,0,0.5],
                           xticklabelsvisible = true,
                           yticklabelsvisible = false,
                           xtickalign = 1,
                           ytickalign = 1,
                          )

                # Plot the data distribution
                scatter!(ax1, X[:,idx], y, color = (:blue,0.5), markersize = 20)
                scatter!(ax2, X[:,idx+1], y, color = (:blue,0.5), markersize = 20)
                plt_idx < 9 && scatter!(ax3, X[:,idx+2], y, color = (:blue,0.5), markersize = 20)
                plt_idx < 9 && (ax3.xlabel= labels[idx+2])
                plt_idx < 9 && (ax3.title = titles[idx+2])

                # Export the figure
                savefig("distribution/$plt_idx.png", fig)
                plt_idx = plt_idx + 1
        end
end
