#' Use the depth-first search (dfs) algorithm
#'
#' @description
#'
#' With a chosen or random node serving as the starting point, perform a
#' depth-first search of the whole graph and return the node ID values visited.
#' The dfs algorithm differs from breadth-first search (bfs) in that dfs will
#' follow tree branches as far as possible until terminating at leaf node (bfs
#' traverses branches one level at a time).
#'
#' @inheritParams render_graph
#' @param node An optional node ID value to specify a single starting point for
#'   the dfs. If not provided, a random node from the graph will be chosen.
#' @param direction Using `all` (the default), the bfs will ignore edge
#'   direction while traversing through the graph. With `out` and `in`,
#'   traversals between adjacent nodes will respect the edge direction.
#'
#' @return A vector containing node ID values for nodes visited during the
#'   depth-first search. The order of the node IDs corresponds to the order
#'   visited.
#'
#' @examples
#' # Create a graph containing
#' # two balanced trees
#' graph <-
#'   create_graph() %>%
#'   add_balanced_tree(
#'     k = 2, h = 2) %>%
#'   add_balanced_tree(
#'   k = 3, h = 2)
#'
#' # Perform a depth-first
#' # search of the graph,
#' # beginning at the root
#' # node `1` (the default
#' # `direction = "all"`
#' # doesn't take edge
#' # direction into account)
#' graph %>%
#'   do_dfs(node = 1)
#'
#' # If not specifying a
#' # starting node, the function
#' # will begin the search
#' # from a random node
#' graph %>%
#'   do_dfs()
#'
#' # It's also possible to
#' # perform dfs while taking
#' # into account edge direction;
#' # using `direction = "in"`
#' # causes the dfs routine to
#' # visit nodes along inward edges
#' graph %>%
#'   do_dfs(
#'     node = 1,
#'     direction = "in")
#'
#' # Using `direction = "out"`
#' # results in the dfs moving
#' # along solely outward edges
#' graph %>%
#'   do_dfs(
#'     node = 1,
#'     direction = "out")
#'
#' @export
do_dfs <- function(
    graph,
    node = NULL,
    direction = "all"
) {

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Validation: Graph contains nodes
  check_graph_contains_nodes(graph)

  # Validation: direction is in the allowed values.
  rlang::arg_match0(direction, c("all", "out", "in"))

  # If no node provided, choose a random node
  if (is.null(node)) {
    node <- sample(graph$nodes_df[, 1], 1)
  }

  # Convert the graph to an igraph object
  ig_graph <- to_igraph(graph)

  # Perform the depth-first search algorithm in
  # the direction requested
  if (direction == "all") {

    dfs_result <-
      igraph::dfs(
        graph = ig_graph,
        root = node,
        mode = "all")

  } else if (direction == "out") {

    dfs_result <-
      igraph::dfs(
        graph = ig_graph,
        root = node,
        mode = "out")

  } else if (direction == "in") {

    dfs_result <-
      igraph::dfs(
        graph = ig_graph,
        root = node,
        mode = "in")

  }

  # Get the nodes visited during the dfs
  as.integer(as.numeric(dfs_result$order))
}
