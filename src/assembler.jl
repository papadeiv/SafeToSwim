using DataFrames, CSV 
using ProgressMeter

include("./flow_assembler.jl")
include("./rainfall_assembler.jl")

function assembler(SiteName,FlowSiteName,RainfallSiteName)
        # Generate the flow and rainfall lagged observation matrices
        flow_assembler(SiteName,FlowSiteName)
        rainfall_assembler(SiteName,RainfallSiteName)

        # Loop over the observation matrices
        flow_matrix = nothing 
        flow_names = nothing 
        rainfall_matrix = nothing 
        rainfall_names = nothing 
        flow_sample_names = String[]
        rainfall_sample_names = String[]
        printstyled("Assembling the data matrices\n"; bold=true, underline=true, color=:light_blue)
        @showprogress for n in 2:7
                # Extract the flow data 
                filename = "observations/flow_max/$n.csv"
                df = CSV.read("../data/"*filename, DataFrame)
                flow_ecoli_dates = df[!,(names(df))[1]]
                flow_ecoli_value = df[!,(names(df))[2]]
                flow_dates = df[!,(names(df))[3]]
                flow_value = df[!,(names(df))[4]]
                max_flow_value = df[!,(names(df))[5]]
                tot_flow_value = df[!,(names(df))[6]]
                flow_names = [(names(df))[m] for m in 1:6]

                # Extract the rainfall data 
                filename = "observations/rainfall/$n.csv"
                df = CSV.read("../data/"*filename, DataFrame)
                rainfall_ecoli_dates = df[!,(names(df))[1]]
                rainfall_ecoli_value = df[!,(names(df))[2]]
                rainfall_dates = df[!,(names(df))[3]]
                rainfall_value = df[!,(names(df))[4]]
                max_rainfall_value = df[!,(names(df))[5]]
                tot_rainfall_value = df[!,(names(df))[6]]
                rainfall_names = [(names(df))[m] for m in 1:6]

                # Append columns to the data matrix
                if n==2
                        flow_sample_names = [flow_names[1], flow_names[2], flow_names[4], flow_names[5], flow_names[6]] 
                        flow_matrix = hcat(flow_ecoli_dates,
                                           flow_ecoli_value,
                                           flow_value,
                                           max_flow_value,
                                           tot_flow_value
                                          ) 
                        rainfall_sample_names = [rainfall_names[1], rainfall_names[2], rainfall_names[4], rainfall_names[5], rainfall_names[6]] 
                        rainfall_matrix = hcat(rainfall_ecoli_dates,
                                               rainfall_ecoli_value,
                                               rainfall_value,
                                               max_rainfall_value,
                                               tot_rainfall_value
                                              )
                else
                        flow_sample_names = vcat(flow_sample_names, flow_names[5], flow_names[6])
                        flow_matrix = hcat(flow_matrix, max_flow_value, tot_flow_value)
                        rainfall_sample_names = vcat(rainfall_sample_names, rainfall_names[5], rainfall_names[6])
                        rainfall_matrix = hcat(rainfall_matrix, max_rainfall_value, tot_rainfall_value)
                end
        end

        # Return the observation matrices
        return(
               flow_matrix = DataFrame(flow_matrix, Symbol.(flow_sample_names)),
               rainfall_matrix = DataFrame(rainfall_matrix, Symbol.(rainfall_sample_names)),
              )
end
