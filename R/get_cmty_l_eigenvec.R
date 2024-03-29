#' Get community membership by leading eigenvector
#'
#' @description
#'
#' Through the calculation of the leading non-negative eigenvector of the
#' modularity matrix of the graph, obtain the group membership values for each
#' of the nodes in the graph.
#'
#' @inheritParams render_graph
#'
#' @return A data frame with group membership assignments for each of the nodes.
#'
#' @examples
#' # Create a random graph using the
#' # `add_gnm_graph()` function
#' graph <-
#'   create_graph(
#'     directed = FALSE) %>%
#'   add_gnm_graph(
#'     n = 10,
#'     m = 15,
#'     set_seed = 23)
#'
#' # Get the group membership
#' # values for all nodes in the
#' # graph through calculation of
#' # the leading non-negative
#' # eigenvector of the modularity
#' # matrix of the graph
#' graph %>%
#'   get_cmty_l_eigenvec()
#'
#' # Add the group membership
#' # values to the graph as a node
#' # attribute
#' graph <-
#'   graph %>%
#'   join_node_attrs(
#'     df = get_cmty_l_eigenvec(.))
#'
#' # Display the graph's node data frame
#' graph %>% get_node_df()
#'
#' @export
get_cmty_l_eigenvec <- function(graph) {

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # If graph is directed, transform to undirected
  graph <- set_graph_undirected(graph)

  # Convert the graph to an igraph object
  ig_graph <- to_igraph(graph)

  # Get the community object using the
  # `cluster_leading_eigen()` function
  cmty_l_eigenvec_obj <-
    igraph::cluster_leading_eigen(ig_graph)

  # Create df with node memberships
  data.frame(
    id = igraph::membership(cmty_l_eigenvec_obj) %>% names() %>% as.integer(),
    l_eigenvec_group = as.vector(igraph::membership(cmty_l_eigenvec_obj)),
    stringsAsFactors = FALSE)
}
