using DataFrames, CairoMakie
using ProgressMeter

include("../src/flow_parser.jl")
include("../src/export_figure.jl")

# Import the data 
filename = "flow/Flow_Max.csv"
site_idx = 111
data = flow_parser(filename, site_idx)

# Extract the dates
dates = Date.(string.(data.data[:,1]), DateFormat("yyyy-mm-d"))

# Check daily incremental
non_consecutive_idx = findall(diff(dates) .!= Day(1))

for idx in non_consecutive_idx
        println(idx, ") ", dates[idx], " --> ", dates[idx+1])
end
