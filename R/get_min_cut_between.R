#' Get the minimum cut between source and sink nodes
#'
#' @description
#'
#' Get the minimum cut between source and sink nodes. This is the minimum total
#' capacity of edges needed for removal in order to eliminate all paths from the
#' source and sink nodes.
#'
#' @inheritParams render_graph
#' @param from The node ID for the source node.
#' @param to The node ID for the sink or target node.
#'
#' @return A single numeric value representing the minimum total edge capacity
#'   removed to disconnect the source and sink nodes.
#'
#' @examples
#' # Set a seed
#' suppressWarnings(RNGversion("3.5.0"))
#' set.seed(23)
#'
#' # Create a cycle graph
#' graph <-
#'   create_graph() %>%
#'   add_cycle(n = 5)
#'
#' # Determine the minimum cut
#' # between nodes `1` and `4`
#' graph %>%
#'   get_min_cut_between(
#'     from = 1,
#'     to = 2)
#'
#' # Create a cycle graph with
#' # randomized values given to all
#' # edges as the `capacity` attribute
#' graph_capacity <-
#'   create_graph() %>%
#'   add_cycle(n = 5) %>%
#'   select_edges() %>%
#'   set_edge_attrs_ws(
#'     edge_attr = capacity,
#'     value =
#'       rnorm(
#'         n = count_edges(.),
#'         mean = 5,
#'         sd = 1)) %>%
#'   clear_selection()
#'
#' # Determine the minimum cut
#' # between nodes `1` and `4` for
#' # this graph, where `capacity`is
#' # set as an edge attribute
#' graph_capacity %>%
#'   get_min_cut_between(
#'     from = 1,
#'     to = 2)
#'
#' # Create a full graph and then
#' # get the minimum cut requirement
#' # between nodes `2` and `8`
#' create_graph() %>%
#'   add_full_graph(n = 10) %>%
#'   get_min_cut_between(
#'     from = 2,
#'     to = 8)
#'
#' @export
get_min_cut_between <- function(
    graph,
    from,
    to
) {

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # If the graph is empty, then return NA
  if (nrow(graph$nodes_df) == 0) {
    return(NA_real_)
  }

  # Convert the graph to an igraph object
  ig_graph <- to_igraph(graph)

  # Get the minimum cut value for removing
  # all paths from the source to the sink
  igraph::min_cut(
    graph = ig_graph,
    source = from,
    target = to)
}
