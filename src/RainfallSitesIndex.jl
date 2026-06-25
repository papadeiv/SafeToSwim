using CSV, DataFrames

# This function takes a string of a rainfall site as input and outputs the number of the 
# column for that site in the RFTOTAL.csv 

function FindRainfallSiteIndex(RainfallSiteName)
	df = CSV.read("/Users/dmit755/Desktop/MINZ_2026/data/rainfall/RFTOTAL.csv", DataFrame)
	idx = findfirst(==(RainfallSiteName), names(df))
	return idx
end