using DataFrames, CSV

include("./RainfallSitesIndex.jl")
include("./rainfall_parser.jl")

function rainfall_assembler(EColiSiteName, RainfallSiteName)
        # Import and extract the rainfall data
        filename = "rainfall/RFTOTAL.csv"
        site_idx = FindRainfallSiteIndex(RainfallSiteName)
        data = rainfall_parser(filename, site_idx)
        rainfall_dates = Date.(string.(data.data[:,1]), DateFormat("yyyy-mm-d"))
        rainfall_value = float.(data.data[:,2])

        # Import the and extract E.coli data
        data = CSV.read("../data/ecoli/$EColiSiteName.csv", DataFrame)
        ecoli_dates = Date.(string.(data[:,1]), DateFormat("yyyy-mm-d"))
        ecoli_value = float.(data[:,2])

        # Loop over the E.coli measurements 
        rainfall_idx = Integer[]
        ecoli_idx = Integer[]
        for (idx, date) in enumerate(ecoli_dates)
                # Check if the E.coli measurement date matches a flow measurement date
                if date ∈ rainfall_dates
                        # Update the measurement date index
                        push!(ecoli_idx, idx)
                        push!(rainfall_idx, findfirst(==(date), rainfall_dates) - 1)
                end
        end

        # Loop over the different lags
        for m in 1:6
                # Build the observation matrix
                observation_matrix = Matrix{Any}(undef, length(ecoli_idx), 6)
                observation_matrix[:,1] = ecoli_dates[ecoli_idx]
                observation_matrix[:,2] = ecoli_value[ecoli_idx]
                observation_matrix[:,3] = rainfall_dates[rainfall_idx]
                observation_matrix[:,4] = rainfall_value[rainfall_idx]

                # Loop over the measurement indices
                for (n, idx) in enumerate(rainfall_idx)
                        # Assemble the array of lagged observations
                        lagged_observations = Float64[]
                        push!(lagged_observations, rainfall_value[idx])
                        for lag_idx in 1:m 
                                push!(lagged_observations, rainfall_value[idx - lag_idx])
                        end

                        # Compute the observables of the lagged observations
                        observation_matrix[n,5] = maximum(lagged_observations)
                        observation_matrix[n,6] = sum(lagged_observations) 
                end

                # Export the observation matrix
                colnames = ["E.coli date", 
                            "E.coli value", 
                            "Max rainfall date (past 24 hours)", 
                            "Max rainfall value (past 24 hours)", 
                            "Max rainfall value (past $(24*(m+1)) hours)", 
                            "Total rainfall value (past $(24*(m+1)) hours)", 
                           ]
                df = DataFrame(observation_matrix, Symbol.(colnames))
                CSV.write("../data/observations/rainfall/$(m+1).csv", df)
        end       
end
