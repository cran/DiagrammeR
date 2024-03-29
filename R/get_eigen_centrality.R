#' Get the eigen centrality for all nodes
#'
#' @description
#'
#' Get the eigen centrality values for all nodes in the graph.
#'
#' @inheritParams render_graph
#' @param weights_attr An optional name of the edge attribute to use in the
#'   adjacency matrix. If `NULL` then, if it exists, the `weight` edge attribute
#'   of the graph will be used. If `NA` then no edge weights will be used.
#'
#' @return A data frame with eigen centrality scores for each of the nodes.
#'
#' @examples
#' # Create a random graph using the
#' # `add_gnm_graph()` function
#' graph <-
#'   create_graph(
#'     directed = FALSE) %>%
#'   add_gnm_graph(
#'     n = 10, m = 15,
#'     set_seed = 23)
#'
#' # Get the eigen centrality scores
#' # for nodes in the graph
#' graph %>% get_eigen_centrality()
#'
#' @export
get_eigen_centrality <- function(
    graph,
    weights_attr = NULL
) {

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Convert the graph to an igraph object
  ig_graph <- to_igraph(graph)

  if (inherits(weights_attr, "character")) {
    # Stop function if the edge attribute does not exist
    if (!(weights_attr %in% colnames(graph$edges_df))) {

      cli::cli_abort(
        "The edge attribute to be used as weights does not exist in the graph.")
    }

    # Stop function if the edge attribute is not numeric
    if (!is.numeric(graph$edges_df[, which(colnames(graph$edges_df) == weights_attr)])) {

      cli::cli_abort(
        "The edge attribute to be used as weights is not numeric.")
    }

    weights_attr <- graph$edges_df[, which(colnames(graph$edges_df) == weights_attr)]
  }

  # Get the eigen centrality values for each of the
  # graph's nodes
  eigen_centrality_values <-
    igraph::eigen_centrality(
      graph = ig_graph,
      weights = weights_attr)

  # Create df with eigen centrality values
  data.frame(
    id = names(eigen_centrality_values$vector) %>% as.integer(),
    eigen_centrality = unname(eigen_centrality_values$vector) %>% round(4),
    stringsAsFactors = FALSE)
}
