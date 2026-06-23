using DataFrames, CSV

include("./flow_parser.jl")
include("./ecoli_parser.jl")

function flow_assembler()
        # Import the flow data
        filename = "flow/Flow_Max.csv"
        site_idx = 111
        data = flow_parser(filename, site_idx)

        # Extract the dates and flow
        flow = float.(data.data[:,2])
        dates = Date.(string.(data.data[:,1]), DateFormat("yyyy-mm-d"))

        # Import the E.coli data
        filename = "ecoli/$(data.site).csv"
        data = ecoli_parser(filename, 2)

        # Match the dates between flow (daily) and E.coli (weekly) measurements
        matching_idx = filter(!isnothing, [findfirst(==(date), dates) for date in data.data[:,1]]) .- 1

        # Loop over the different lags
        for m in 1:6
                # Loop over the matching indices
                flow_matrix = Matrix{Any}(undef, length(matching_idx), 4)
                for (n, idx) in enumerate(matching_idx)
                        # Fill-in the date and past 24hr flow
                        flow_matrix[n,1] = dates[idx]
                        flow_matrix[n,2] = flow[idx]

                        # Assemble the array of lagged observations
                        lagged_observations = Float64[]
                        push!(lagged_observations, flow[idx])
                        for lag_idx in 1:m 
                                push!(lagged_observations, flow[idx - lag_idx])
                        end

                        # Compute the observables of the lagged observations
                        flow_matrix[n,3] = maximum(lagged_observations)
                        flow_matrix[n,4] = sum(lagged_observations) 
                end

                # Export the observation matrix
                colnames = ["day", "1 day", "$(m+1) days max", "$(m+1) days total"]
                df = DataFrame(flow_matrix, Symbol.(colnames))
                CSV.write("../data/observations/flow_max/$(m+1).csv", df)
        end       
end
