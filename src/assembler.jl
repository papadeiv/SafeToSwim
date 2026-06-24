using DataFrames, CSV 
using ProgressMeter

include("./flow_assembler.jl")
include("./rainfall_assembler.jl")

function assembler()
        # Generate the flow and rainfall lagged observation matrices
        flow_assembler()
        rainfall_assembler()

        # Loop over the observation matrices
        flow_matrix = nothing 
        flow_names = nothing 
        rainfall_matrix = nothing 
        rainfall_names = nothing 
        printstyled("Assembling the data matrices\n"; bold=true, underline=true, color=:light_blue)
        @showprogress for n in 2:7
                # Import the max flow data 
                filename = "observations/flow_max/$n.csv"
                df = CSV.read("../data/"*filename, DataFrame)

                # Define the data arrays
                dates_flow = df[!,(names(df))[1]]
                daily_flow = df[!,(names(df))[2]]
                max_past_days_flow = df[!,(names(df))[3]]
                tot_past_days_flow = df[!,(names(df))[4]]

                #=
                # Import the rainfall data 
                filename = "observations/rainfall/$n.csv"
                df = CSV.read("../data/"*filename, DataFrame)

                # Define the data arrays
                dates_rainfall = df[!,(names(df))[1]]
                daily_rainfall = df[!,(names(df))[2]]
                max_past_days_rainfall = df[!,(names(df))[3]]
                tot_past_days_rainfall = df[!,(names(df))[4]]
                =#

                # Append columns to the data matrix
                if n==2
                        flow_names = [(names(df))[m] for m in 1:4] 
                        flow_matrix = hcat(dates_flow,
                                                  daily_flow,
                                                  max_past_days_flow,
                                                  tot_past_days_flow
                                                 ) 
                        #=
                        global flow_matrix = hcat(dates_rainfall,
                                                  daily_rainfall,
                                                  max_past_days_rainfall,
                                                  tot_past_days_rainfall
                                                 ) 
                        =#
                else
                        flow_names = vcat(flow_names, (names(df))[3], (names(df))[4]) 
                        flow_matrix = hcat(flow_matrix, max_past_days_flow, tot_past_days_flow)
                        #global rainfall_matrix = hcat(rainfall_matrix, max_past_days_rainfall, tot_past_days_rainfall)
                end
        end

        # Return the observation matrices
        return(
               flow_matrix = DataFrame(flow_matrix, Symbol.(flow_names)),
               rainfall_matrix = DataFrame(flow_matrix, Symbol.(flow_names)),
              )
end
