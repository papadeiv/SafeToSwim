using CSV, Dates, DataFrames

function ecoli_parser(filename)
       # Import the file 
       df = CSV.read("../data/ecoli_decomposed/"*filename, DataFrame)

       # Define the data arrays
       timestep = df[!,(names(df))[1]]
       dates = Date.(timestep, dateformat"yyyy-mm-dd")
       feature = (names(df))[2]
       ecoli = df[!, feature]

       return(
              label = feature,
              data = hcat(dates, ecoli)
             )
end
