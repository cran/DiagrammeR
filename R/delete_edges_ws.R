#' Delete all selected edges in an edge selection
#'
#' @description
#'
#' In a graph object of class `dgr_graph`, delete all edges present in a
#' selection.
#'
#' This function makes use of an active selection of edges (and the function
#' ending with `_ws` hints at this).
#'
#' Selections of edges can be performed using the following selection
#' (`select_*()`) functions: [select_edges()], [select_last_edges_created()],
#' [select_edges_by_edge_id()], or [select_edges_by_node_id()].
#'
#' Selections of edges can also be performed using the following traversal
#' (`trav_*()`) functions: [trav_out_edge()], [trav_in_edge()],
#' [trav_both_edge()], or [trav_reverse_edge()].
#'
#' @inheritParams render_graph
#'
#' @return A graph object of class `dgr_graph`.
#'
#' @examples
#' # Create a graph
#' graph <-
#'   create_graph() %>%
#'   add_n_nodes(n = 3) %>%
#'   add_edges_w_string(
#'     edges = "1->3 1->2 2->3")
#'
#' # Select edges attached to
#' # node with ID `3` (these are
#' # `1`->`3` and `2`->`3`)
#' graph <-
#'   graph %>%
#'   select_edges_by_node_id(nodes = 3)
#'
#' # Delete edges in selection
#' graph <-
#'   graph %>%
#'   delete_edges_ws()
#'
#' # Get a count of edges in the graph
#' graph %>% count_edges()
#'
#' @family edge creation and removal
#'
#' @export
delete_edges_ws <- function(graph) {

  # Get the time of function start
  time_function_start <- Sys.time()

  # Get the name of the function
  fcn_name <- get_calling_fcn()

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Validation: Graph contains nodes
  check_graph_contains_nodes(graph, "So, there cannot be edges to delete.")

  # Validation: Graph contains edges
  check_graph_contains_edges(graph)

  # Validation: Graph object has valid edge selection
  check_graph_contains_edge_selection(graph)

  # Get vectors of the nodes in edges to be deleted
  from_delete <- graph$edge_selection$from
  to_delete <- graph$edge_selection$to

  # Get the number of edges in the graph
  edges_graph_1 <- graph %>% count_edges()

  # Delete all edges in selection
  for (i in seq_along(from_delete)) {
    graph <-
      delete_edge(
        graph = graph,
        from = from_delete[i],
        to = to_delete[i])
  }

  # Replace `graph$node_selection` with an empty df
  graph$node_selection <- create_empty_nsdf()

  # Replace `graph$edge_selection` with an empty df
  graph$edge_selection <- create_empty_esdf()

  # Remove any `delete_edge` records from the graph log
  graph$graph_log <-
    graph$graph_log[-((nrow(graph$graph_log) - (i - 1)):nrow(graph$graph_log)), ]

  # Scavenge any invalid, linked data frames
  graph <-
    remove_linked_dfs(graph)

  # Get the updated number of edges in the graph
  edges_graph_2 <- graph %>% count_edges()

  # Get the number of edges added to
  # the graph
  edges_removed <- edges_graph_2 - edges_graph_1

  # Update the `graph_log` df with an action
  graph$graph_log <-
    add_action_to_log(
      graph_log = graph$graph_log,
      version_id = nrow(graph$graph_log) + 1L,
      function_used = fcn_name,
      time_modified = time_function_start,
      duration = graph_function_duration(time_function_start),
      nodes = nrow(graph$nodes_df),
      edges = nrow(graph$edges_df),
      d_e = edges_removed)

  # Perform graph actions, if any are available
  if (nrow(graph$graph_actions) > 0) {
    graph <-
      trigger_graph_actions(graph)
  }

  # Write graph backup if the option is set
  if (graph$graph_info$write_backups) {
    save_graph_as_rds(graph)
  }

  graph
}
