#' Get closeness vitality
#'
#' @description
#'
#' Get the closeness vitality values for all nodes in the graph.
#'
#' @inheritParams render_graph
#'
#' @return A data frame with closeness vitality values for each of the nodes.
#'
#' @examples
#' # Create a random graph using the
#' # `add_gnm_graph()` function
#' graph <-
#'   create_graph() %>%
#'   add_gnm_graph(
#'     n = 10,
#'     m = 12,
#'     set_seed = 23)
#'
#' # Get closeness vitality values
#' # for all nodes in the graph
#' graph %>% get_closeness_vitality()
#'
#' # Add the closeness vitality
#' # values to the graph as a
#' # node attribute
#' graph <-
#'   graph %>%
#'   join_node_attrs(
#'     df = get_closeness_vitality(.))
#'
#' # Display the graph's
#' # node data frame
#' graph %>% get_node_df()
#'
#' @export
get_closeness_vitality <- function(graph) {

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Convert the graph to an igraph object
  ig_graph <- to_igraph(graph)

  # Get the sum of distances between all pairs
  # of nodes in the graph
  sum_distances <- sum(igraph::distances(ig_graph))

  # Calculated closeness vitality values for
  # all nodes in the graph
  closeness_vitality_values <-
    purrr::map(
      seq_len(nrow(graph$nodes_df)),
      function(x) {
        distances <- igraph::distances(igraph::delete_vertices(ig_graph, x))
        sum_distances - sum(distances[!is.infinite(distances)])
      }) %>% unlist()

  # Create df with closeness vitality values
  data.frame(
    id = graph$nodes_df$id,
    closeness_vitality = closeness_vitality_values,
    stringsAsFactors = FALSE)
}
