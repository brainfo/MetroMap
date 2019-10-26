include("../src/MetroMapRuby.jl")
using MetroMapRuby
using Test
using JuMP
using GLPKMathProgInterface

tests = [
    "model1",
    "label-placement",
    "model2",
    "model-faces",
    "reduce-map"
    ]

println("Running tests:")

for t in tests
    test_fn = "$t.jl"
    println(" * $test_fn")
    include(test_fn)
end

include("model1.jl")
