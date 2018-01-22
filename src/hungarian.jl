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

  # remove weights that are not in the graph, i.e. set them to a large value to ensure they are not taken
  scale = - 2 * one(T) * maximum(w)
  for j in 1:n
    for i in 1:n
      # if i > j  && w[i,j] > zero(T) && w[j,i] < w[i,j]
      #   w[j,i] = w[i,j]
      # end
      if Edge(i, j) ∉ edge_list
        println("Rescaled: ($i, $j); was: $(w[i, j])")
        w[i, j] = scale
      end
    end
  end

  # call the library and convert to the right format
  # hungarian() minimises the total cost, while this function is supposed to maximise the total weights
  println(w)
  println(maximum(w) - w)
  assignment, hc = Hungarian.hungarian(maximum(w) - w)
  println("Hungarian: $(maximum(w) - hc)")

  mate = fill(-1, nv(g)) # initialise to unmatched
  for i in 1:length(assignment)
    if assignment[i] != 0 # if matched
      mate[i] = assignment[i]
      mate[assignment[i]] = i
    end
  end

  cost = zero(T)
  for i in 1:length(assignment)
    if assignment[i] != 0 && Edge(i, assignment[i]) ∈ edge_list # if matched and allowed (with the high cost for these edges, only chosen to have a maximum matching)
      println(w[i, assignment[i]])
      cost += w[i, assignment[i]]
    end
  end

  println("==================================")

  # return the result
  return MatchingResult(cost, mate)
end