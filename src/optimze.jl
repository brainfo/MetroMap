function optimize(solver::MathProgBase.SolverInterface.AbstractMathProgSolver,
                    transit_map::InputGraph, planarity_constraints::Integer,
                    elen_factor::Integer = 3,
                    bc_factor::Integer = 3,
                    rpos_factor::Integer = 1)
    input_graph = transit_map
    station_list = stations(input_graph)
    edge_list = edges(input_graph)
    faces = edge_faces(input_graph)
    model = Model(solver = solver)
    variables = build_model!(model, input_graph, faces, planarity_constraints,
                                    elen_factor, elen_factor, rpos_factor)
    status = solve(model)
    x_val = getvalue(variables.x)
    y_val = getvalue(variables.y)
    function map_station(i)
        station = station_list[i]
        coord = EuclideanCoordinate(round(x_val[i], 6), round(y_val[i], 6))
        EuclideanStation(station.id, coord, station.label, station.is_dummy)
    end
    euclidian_stations = map(map_station, 1:nstations(input_graph))
    function map_edge(edge)
        idx_from = first(indexin([edge.from], station_list))
        idx_to = first(indexin([edge.to], station_list))
        Edge(euclidian_stations[idx_from],
             euclidian_stations[idx_to], edge.line)
    end
    euclidian_edges = map(map_edge, edges(input_graph))
    TransitMapLayout(euclidian_stations,
        euclidian_edges,
        input_graph.lines,
        faces)
end
