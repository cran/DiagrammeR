#' Get the graph's ndf filtered by a selection of nodes
#'
#' @description
#'
#' From a graph object of class `dgr_graph`, get the graph's internal node data
#' frame that is filtered by the node ID values currently active as a selection.
#'
#' This function makes use of an active selection of nodes (and the function
#' ending with `_ws` hints at this).
#'
#' Selections of nodes can be performed using the following node selection
#' (`select_*()`) functions: [select_nodes()], [select_last_nodes_created()],
#' [select_nodes_by_degree()], [select_nodes_by_id()], or
#' [select_nodes_in_neighborhood()].
#'
#' Selections of nodes can also be performed using the following traversal
#' (`trav_*()`) functions: [trav_out()], [trav_in()], [trav_both()],
#' [trav_out_node()], [trav_in_node()], [trav_out_until()], or
#' [trav_in_until()].
#'
#' @inheritParams render_graph
#'
#' @return A node data frame.
#'
#' @examples
#' # Create a random graph using the
#' # `add_gnm_graph()` function
#' graph <-
#'   create_graph() %>%
#'   add_gnm_graph(
#'     n = 4,
#'     m = 4,
#'     set_seed = 23) %>%
#'   set_node_attrs(
#'     node_attr = value,
#'     values = c(2.5, 8.2, 4.2, 2.4))
#'
#' # Select nodes with ID values
#' # `1` and `3`
#' graph <-
#'   graph %>%
#'   select_nodes_by_id(
#'     nodes = c(1, 3))
#'
#' # Get the node data frame that's
#' # limited to the rows that correspond
#' # to the node selection
#' graph %>% get_node_df_ws()
#'
#' @export
get_node_df_ws <- function(graph) {

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Validation: Graph object has a valid node selection
  check_graph_contains_node_selection(graph)

  # Extract the node data frame (ndf)
  # from the graph and get only those nodes
  # from the node selection
  graph$nodes_df %>%
    dplyr::filter(id %in% graph$node_selection$node)
}
