using DataFrames, CSV

include("./flow_parser.jl")
include("./ecoli_parser.jl")

function flow_assembler()
        # Import and extract the flow data
        filename = "flow/Flow_Max.csv"
        site_idx = 111
        data = flow_parser(filename, site_idx)
        flow_dates = Date.(string.(data.data[:,1]), DateFormat("yyyy-mm-d"))
        flow_value = float.(data.data[:,2])

        # Import the and extract E.coli data
        filename = "ecoli/$(data.site).csv"
        data = ecoli_parser(filename, 2)
        ecoli_dates = Date.(string.(data.data[:,1]), DateFormat("yyyy-mm-d"))
        ecoli_value = float.(data.data[:,2])

        # Loop over the E.coli measurements 
        flow_idx = Integer[]
        ecoli_idx = Integer[]
        for (idx, date) in enumerate(ecoli_dates)
                # Check if the E.coli measurement date matches a flow measurement date
                if date ∈ flow_dates
                        # Update the measurement date index
                        push!(ecoli_idx, idx)
                        push!(flow_idx, findfirst(==(date), flow_dates) - 1)
                end
        end

        # Loop over the different lags
        for m in 1:6
                # Build the observation matrix
                observation_matrix = Matrix{Any}(undef, length(ecoli_idx), 6)
                observation_matrix[:,1] = ecoli_dates[ecoli_idx]
                observation_matrix[:,2] = ecoli_value[ecoli_idx]
                observation_matrix[:,3] = flow_dates[flow_idx]
                observation_matrix[:,4] = flow_value[flow_idx]

                # Loop over the measurement indices
                for (n, idx) in enumerate(flow_idx)
                        # Assemble the array of lagged observations
                        lagged_observations = Float64[]
                        push!(lagged_observations, flow_value[idx])
                        for lag_idx in 1:m 
                                push!(lagged_observations, flow_value[idx - lag_idx])
                        end

                        # Compute the observables of the lagged observations
                        observation_matrix[n,5] = maximum(lagged_observations)
                        observation_matrix[n,6] = sum(lagged_observations) 
                end

                # Export the observation matrix
                colnames = ["E.coli date", 
                            "E.coli value", 
                            "Max flow date (past 24 hours)", 
                            "Max flow value (past 24 hours)", 
                            "Max flow value (past $(24*(m+1)) hours)", 
                            "Total flow value (past $(24*(m+1)) hours)", 
                           ]
                df = DataFrame(observation_matrix, Symbol.(colnames))
                CSV.write("../data/observations/flow_max/$(m+1).csv", df)
        end       
end
