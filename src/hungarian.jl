"""
maximum_weight_matching_hungarian{T <:Real}(g::Graph, w::Dict{Edge,T} = Dict{Edge,Int64}())

Given a graph `g` and an edgemap `w` containing weights associated to edges,
returns a matching with the maximum total weight.
`w` is a dictionary that maps edges i => j to weights.
If no weight parameter is given, all edges will be considered to have weight 1
(results in max cardinality matching). 

The algorithm is always polynomial in time, with complexity O(n³). 

Returns MatchingResult containing:
  - the optimal cost
  - a list of each vertex's match (or -1 for unmatched vertices)
"""
function maximum_weight_matching_hungarian end

function maximum_weight_matching_hungarian(g::Graph,
          w::AbstractMatrix{T} = default_weights(g)) where {T <:Real}
  edge_list = collect(edges(g))
  n = nv(g)

  # remove weights that are not in the graph
  for j in 1:n
    for i in 1:n
      if Edge(i, j) ∉ edge_list
        w[i, j] = zero(T)
      end
    end
  end

  # call the library and convert to the right format
  # hungarian() minimises the total cost, while this function is supposed to maximise the total weights
  assignment, cost = Hungarian.hungarian(- w)
  mate = fill(-1, nv(g)) # initialise to unmatched
  for i in 1:length(assignment)
    if assignment[i] != 0 # if matched
      mate[i] = assignment[i]
      mate[assignment[i]] = i
    end
  end

  # return the result
  return MatchingResult(- cost, mate)
end