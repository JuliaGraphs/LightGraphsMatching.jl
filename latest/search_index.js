var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Getting started",
    "title": "Getting started",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#LightGraphsMatching.MatchingResult",
    "page": "Getting started",
    "title": "LightGraphsMatching.MatchingResult",
    "category": "type",
    "text": "type MatchingResult{T}\n    weight::T\n    mate::Vector{Int}\nend\n\nA type representing the result of a matching algorithm.\n\nweight: total weight of the matching\n\nmate:    `mate[i] = j` if vertex `i` is matched to vertex `j`.\n         `mate[i] = -1` for unmatched vertices.\n\n\n\n"
},

{
    "location": "index.html#LightGraphsMatching.maximum_weight_matching",
    "page": "Getting started",
    "title": "LightGraphsMatching.maximum_weight_matching",
    "category": "function",
    "text": "maximum_weight_matching{T <:Real}(g::Graph, w::Dict{Edge,T} = Dict{Edge,Int64}())\n\nGiven a graph g and an edgemap w containing weights associated to edges, returns a matching with the maximum total weight. w is a dictionary that maps edges i => j to weights. If no weight parameter is given, all edges will be considered to have weight 1 (results in max cardinality matching)\n\nThe efficiency of the algorithm depends on the input graph:\n\nIf the graph is bipartite, then the LP relaxation is integral.\nIf the graph is not bipartite, then it requires a MIP solver and\n\nthe computation time may grow exponentially.\n\nThe package JuMP.jl and one of its supported solvers is required.\n\nReturns MatchingResult containing:\n\na solve status (indicating whether the problem was solved to optimality)\nthe optimal cost\na list of each vertex\'s match (or -1 for unmatched vertices)\n\n\n\n"
},

{
    "location": "index.html#LightGraphsMatching.maximum_weight_maximal_matching",
    "page": "Getting started",
    "title": "LightGraphsMatching.maximum_weight_maximal_matching",
    "category": "function",
    "text": "maximum_weight_maximal_matching{T<:Real}(g, w::Dict{Edge,T})\nmaximum_weight_maximal_matching{T<:Real}(g, w::Dict{Edge,T}, cutoff)\n\nGiven a bipartite graph g and an edgemap w containing weights associated to edges, returns a matching with the maximum total weight among the ones containing the greatest number of edges.\n\nEdges in g not present in w will not be considered for the matching.\n\nThe algorithm relies on a linear relaxation on of the matching problem, which is guaranteed to have integer solution on bipartite graps.\n\nEventually a cutoff argument can be given, to reduce computational times excluding edges with weights lower than the cutoff.\n\nThe package JuMP.jl and one of its supported solvers is required.\n\nThe returned object is of type MatchingResult.\n\n\n\n"
},

{
    "location": "index.html#LightGraphsMatching.minimum_weight_perfect_matching",
    "page": "Getting started",
    "title": "LightGraphsMatching.minimum_weight_perfect_matching",
    "category": "function",
    "text": "minimum_weight_perfect_matching{T<:Real}(g, w::Dict{Edge,T})\nminimum_weight_perfect_matching{T<:Real}(g, w::Dict{Edge,T}, cutoff)\n\nGiven a graph g and an edgemap w containing weights associated to edges, returns a matching with the mimimum total weight among the ones containing exactly nv(g)/2 edges.\n\nEdges in g not present in w will not be considered for the matching.\n\nThis function relies on the BlossomV.jl package, a julia wrapper around Kolmogorov\'s BlossomV algorithm.\n\nEventually a cutoff argument can be given, to the reduce computational time excluding edges with weights higher than the cutoff.\n\nThe returned object is of type MatchingResult.\n\nIn case of error try to change the optional argument tmaxscale (default is tmaxscale=10).\n\n\n\n"
},

{
    "location": "index.html#LightGraphsMatching.dict_to_arr-Union{Tuple{E}, Tuple{Int64,JuMP.JuMPArray{T,1,Tuple{Array{E,1}}}}, Tuple{T}} where E<:LightGraphs.SimpleGraphs.SimpleEdge where T<:Real",
    "page": "Getting started",
    "title": "LightGraphsMatching.dict_to_arr",
    "category": "method",
    "text": "Returns an array of mates from a dictionary that maps edges to {0,1} \n\n\n\n"
},

{
    "location": "index.html#LightGraphsMatching.cutoff_weights-Union{Tuple{AbstractArray{T,2},R}, Tuple{R}, Tuple{T}} where R<:Real where T<:Real",
    "page": "Getting started",
    "title": "LightGraphsMatching.cutoff_weights",
    "category": "method",
    "text": "cutoff_weights copies the weight matrix with all elements below cutoff set to 0\n\n\n\n"
},

{
    "location": "index.html#LightGraphsMatching.jl:-matching-algorithms-for-LightGraphs-1",
    "page": "Getting started",
    "title": "LightGraphsMatching.jl: matching algorithms for LightGraphs",
    "category": "section",
    "text": "CurrentModule = LightGraphsMatching\nDocTestSetup = quote\n    using LightGraphsMatching\n    import LightGraphs\n    const lg = LightGraphs\nendModules = [LightGraphsMatching]\nPages = [\"LightGraphsMatching.jl\", \"maximum_weight_matching.jl\", \"lp.jl\", \"blossomv.jl\"]\nOrder = [:function, :type]This is the documentation page for LightGraphsMatching.  In all documentation examples, we assume LightGraphsMatching has been imported into scope and that LightGraphs is available with the alias lg:using LightGraphsMatching\nimport LightGraphs\nconst lg = LightGraphs"
},

]}
