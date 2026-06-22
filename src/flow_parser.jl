using CSV, Dates, DataFrames

function flow_parser(idx)
       # Import the file 
       df = CSV.read("../data/flow/Flow_Min.csv", DataFrame)

       # Define the data arrays
       timestep = df[2:end,(names(df))[1]]
       site = (names(df))[idx]
       river = df[2:end,site]

       # Clean the data
       filter_idx = findall(!ismissing, river)
       date = Date.(timestep[filter_idx], dateformat"d/mm/yyyy HH:MM:SS p")
       flow = parse.(Float64, river[filter_idx])

       # Return parsed data as a matrix
       return (
               data = hcat(date, flow),
               site = site
              )
end
