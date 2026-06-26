using CSV, DataFrames

# This function takes a string of a flow site as input and outputs the number of the 
# column for that site in the Flow_Max.csv 

function FindMaxFlowSiteIndex(FlowSiteName)
	df = CSV.read("../data/flow/Flow_Max.csv", DataFrame)
	idx = findfirst(==(FlowSiteName), names(df))
	return idx
end
