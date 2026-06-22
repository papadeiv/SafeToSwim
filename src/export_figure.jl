using CairoMakie 

function savefig(path, figure)
        # Create the export directory if it doesn't exist
        fullpath = "../figures/" * path 
        mkpath(dirname(fullpath))

        # Export the figure
        save(fullpath, figure)
end
