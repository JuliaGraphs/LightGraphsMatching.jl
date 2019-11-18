"""
maximum_cardinality_matching(g::AbstractGraph{U}) where {U<:Integer}

Given a graph `g` returns a maximum cardinality matching.
This is the same as running `maximum_weight_matching` with default weights (`1`)
but is faster without needing a JuMP solver.

Returns MatchingResult containing:
  - the maximum cardinality that can be achieved
  - a list of each vertex's match (or -1 for unmatched vertices)
"""
function maximum_cardinality_matching(g::AbstractGraph{U}) where {U<:Integer}
    n = nv(g)
    init_matching = maximal_matching(g)

    matching = init_matching.mate
    matching_len = init_matching.weight

    # the number of edges that can possibly be part of a matching
    max_generally_possible = fld(n, 2)

    # the maximal matching is a maximum matching
    if matching_len == max_generally_possible
        return init_matching
    end
    # => there are at least two free vertices

    parents = zeros(Int, n)
    visited = falses(n)
    
    cur_level = Vector{Int}()
    sizehint!(cur_level, n)
    next_level = Vector{Int}()
    sizehint!(next_level, n)

    @inbounds while matching_len < max_generally_possible
        # get starting free vertex
        free_vertex = 0
        found = false
        for v in vertices(g)
            if matching[v] == -1
                visited[v] = true
                free_vertex = v
                push!(cur_level, v)
        
                odd_level = true
                found = false
                # find augmenting path
                while !isempty(cur_level)
                    for v in cur_level
                        if odd_level
                            for t in outneighbors(g, v)
                                # found an augmenting path if connected to a free vertex
                                if matching[t] == -1
                                    # traverse the augmenting path backwards and change the matching
                                    current_src = t
                                    current_dst = v
                                    back_odd_level = true
                                    while current_dst != 0
                                        # add every second edge to the matching (this also overwrites the current matching)
                                        if back_odd_level
                                            matching[current_src] = current_dst
                                            matching[current_dst] = current_src
                                        end
                                        current_src = current_dst
                                        current_dst = parents[current_dst]
                                        back_odd_level = !back_odd_level
                                    end
                                    # added exactly one edge to the matching
                                    matching_len += 1
                                    # terminate current search
                                    found = true
                                    break
                                end

                                # use a non matching edge
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

                    odd_level = !odd_level
                    found && break
                end # end finding augmenting path 
                found && break
                parents .= 0
                visited .= false
            end
        end
        # checked all free vertices:
        # no augmenting path found => no better matching
        !found && break 
    end
    
    return MatchingResult(matching_len, matching)
end

function maximal_matching(g::AbstractGraph{U}) where {U<:Integer}
    n = nv(g)
    matching = fill(-1, n)
    
    # get initial matching
    matching_len = 0
    for e in edges(g)
        # no self loops in matching
        e.src == e.dst && continue
        # if unmatched
        if matching[e.src] == -1 && matching[e.dst] == -1
            matching[e.src] = e.dst
            matching[e.dst] = e.src
            matching_len += 1
        end
    end
    return MatchingResult(matching_len, matching)
end