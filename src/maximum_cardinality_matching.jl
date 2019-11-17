"""
maximum_cardinality_matching(g::Graph)

Given a graph `g` returns a maximum cardinality matching.
This is the same as running `maximum_weight_matching` with default weights (`1`)
but is faster without needing a JuMP solver.

Returns MatchingResult containing:
  - the maximum cardinality that can be achieved
  - a list of each vertex's match (or -1 for unmatched vertices)
"""

struct MatchingResult{U<:Real}
    weight::U
    mate::Vector{Int}
end

function maximum_cardinality_matching(g::AbstractGraph{U}) where U<:Integer
    n = nv(g)
    matching = zeros(U, n)
    
    # the number of edges that can possibly be part of a matching
    max_generally_possible = fld(n, 2)

    # get initial matching
    matching_len = 0
    for e in edges(g)
        # if unmatched
        if matching[e.src] == zero(U) && matching[e.dst] == zero(U)
            matching[e.src] = e.dst
            matching[e.dst] = e.src
            matching_len += 1
        end
    end

    # if there are at least two free vertices
    if matching_len < max_generally_possible

        parents = zeros(U, n)
        visited = falses(n)
        
        @inbounds while matching_len < max_generally_possible
            cur_level = Vector{U}()
            sizehint!(cur_level, n)
            next_level = Vector{U}()
            sizehint!(next_level, n)

            # get starting free vertex
            free_vertex = 0
            found = false
            for v in vertices(g)
                if matching[v] == zero(U)
                    visited[v] = true
                    free_vertex = v
                    push!(cur_level, v)
           
                    level = 1
                    found = false
                    # find augmenting path
                    while !isempty(cur_level)
                        for v in cur_level
                            # use a non matching edge
                            if level % 2 == 1
                                for t in outneighbors(g, v)
                                    # found an augmenting path
                                    if matching[t] == zero(U)
                                        current_src = t
                                        current_dst = v
                                        while current_dst != zero(U)
                                            matching[current_src] = current_dst
                                            matching[current_dst] = current_src
                                            current_src = current_dst
                                            current_dst = parents[current_dst]
                                        end
                                        matching_len += 1
                                        found = true
                                        break
                                    end
                                    if !visited[t] && matching[v] != t
                                        visited[t]  = true
                                        parents[t]  = v
                                        push!(next_level, t)
                                    end
                                end
                                found && break
                            else # use a matching edge
                                t = matching[v]
                                if !visited[t]
                                    visited[t]  = true
                                    parents[t]  = v
                                    push!(next_level, t)
                                end
                            end
                        end

                        empty!(cur_level)
                        cur_level, next_level = next_level, cur_level

                        level += 1
                        found && break
                    end # end finding augmenting path 
                    found && break
                    parents .= zero(U)
                    visited .= false
                end
            end
            # no augmenting path found => no better matching
            !found && break 
        end
    end
    
    return MatchingResult(matching_len, matching)
end

#=
g = Graph(12)
add_edge!(g, 1, 8)
add_edge!(g, 1, 9)
add_edge!(g, 1,12)
add_edge!(g, 2, 7)
add_edge!(g, 3, 8)
add_edge!(g, 3, 9)
add_edge!(g, 3,10)
add_edge!(g, 3,11)
add_edge!(g, 4,10)
add_edge!(g, 4,11)
add_edge!(g, 5,12)
add_edge!(g, 6, 8)
add_edge!(g, 6,12)

maximum_cardinality_matching(g)
=#

function wikipedia()
    g = Graph(Int8(6))
    add_edge!(g, 1, 2)
    add_edge!(g, 1, 4)
    add_edge!(g, 2, 3)
    add_edge!(g, 2, 4)
    add_edge!(g, 3, 5)
    add_edge!(g, 4, 5)
    add_edge!(g, 5, 6)

    mr = maximum_cardinality_matching(g)
    println(typeof(mr.mate))
end