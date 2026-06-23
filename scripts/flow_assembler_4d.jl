using DataFrames, CairoMakie
using ProgressMeter

include("../src/flow_parser.jl")
include("../src/ecoli_parser.jl")
include("../src/export_figure.jl")

# Import the flow data
filename = "flow/Flow_Max.csv"
site_idx = 111
data = flow_parser(filename, site_idx)

# Extract the dates and flow
flow = float.(data.data[:,2])
dates = Date.(string.(data.data[:,1]), DateFormat("yyyy-mm-d"))

# Import the E.coli data
filename = "Banu_Data/$(data.site).csv"
data = ecoli_parser(filename, 2)

# Match the dates between flow (daily) and E.coli (weekly) measurements
matching_idx = filter(!isnothing, [findfirst(==(date), dates) for date in data.data[:,1]]) .- 1

# Loop over the matching indices
flow_matrix = Matrix{Any}(undef, length(matching_idx), 4)
for (n, idx) in enumerate(matching_idx)
        flow_matrix[n,1] = dates[idx]
        flow_matrix[n,2] = flow[idx]
        flow_matrix[n,3] = max(flow[idx],flow[idx-1],flow[idx-2],flow[idx-3])
        flow_matrix[n,4] = flow[idx]+flow[idx-1]+flow[idx-2]+flow[idx-3]
end

colnames = ["day", "1 day", "4 days max", "4 days total"]
df = DataFrame(flow_matrix, Symbol.(colnames))
CSV.write("../data/observations/flow_max/4.csv", df)
