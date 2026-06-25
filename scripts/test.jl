using DataFrames, CSV
using LinearAlgebra, Statistics
using ProgressMeter, CairoMakie

include("../src/general_assembler.jl")

# Build the observation matrices
observation_matrices = general_assembler("Waikawa Estuary at Footbridge","Waikawa at North Manakau Road","Manakau at Manakau")
flow_df = observation_matrices.flow_matrix
rainfall_df = observation_matrices.rainfall_matrix