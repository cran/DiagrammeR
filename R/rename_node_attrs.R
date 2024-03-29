#' Rename a node attribute
#'
#' @description
#'
#' Within a graph's internal node data frame (ndf), rename an existing node
#' attribute.
#'
#' @inheritParams render_graph
#' @param node_attr_from The name of the node attribute that will be renamed.
#' @param node_attr_to The new name of the node attribute column identified in
#'   `node_attr_from`.
#'
#' @return A graph object of class `dgr_graph`.
#'
#' @examples
#' # Create a random graph using the
#' # `add_gnm_graph()` function
#' graph <-
#'   create_graph() %>%
#'   add_gnm_graph(
#'     n = 5,
#'     m = 8,
#'     set_seed = 23) %>%
#'   set_node_attrs(
#'     node_attr = shape,
#'     values = "circle") %>%
#'   set_node_attrs(
#'     node_attr = value,
#'     values = rnorm(
#'       n = count_nodes(.),
#'       mean = 5,
#'       sd = 1) %>% round(1))
#'
#' # Get the graph's internal ndf
#' # to show which node attributes
#' # are available
#' graph %>% get_node_df()
#'
#' # Rename the `value` node
#' # attribute as `weight`
#' graph <-
#'   graph %>%
#'   rename_node_attrs(
#'     node_attr_from = value,
#'     node_attr_to = weight)
#'
#' # Get the graph's internal
#' # ndf to show that the node
#' # attribute had been renamed
#' graph %>% get_node_df()
#'
#' @family node creation and removal
#'
#' @export
rename_node_attrs <- function(
    graph,
    node_attr_from,
    node_attr_to
) {

  # Get the time of function start
  time_function_start <- Sys.time()

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Validation: Graph contains nodes
  check_graph_contains_nodes(graph)

  # Get the requested `node_attr_from`
  node_attr_from <-
    rlang::enquo(node_attr_from) %>% rlang::get_expr() %>% as.character()

  # Get the requested `node_attr_to`
  node_attr_to <-
    rlang::enquo(node_attr_to) %>% rlang::get_expr() %>% as.character()

  # Stop function if `node_attr_from` and
  # `node_attr_to` are identical
  if (node_attr_from == node_attr_to) {

    cli::cli_abort(
      "`node_attr_from` must be different than `node_attr_to` for renaming.")
  }

  # Stop function if `node_attr_to` is `id` or any
  # other column name in the graph's node data frame
  if (any(unique(c("id",
                   colnames(get_node_df(graph)))) %in%
          node_attr_to)) {

    cli::cli_abort(
      "You cannot use {node_attr_to} as a name for `node_attr_to`.")
  }

  # Stop function if `node_attr_from` is `id`, `label`
  # or `type`
  if (any(c("id", "label", "type") %in%
          node_attr_from)) {

    cli::cli_abort(
      "You cannot use {node_attr_from} as a name for `node_attr_from`.")
  }

  # Get the number of nodes ever created for
  # this graph
  nodes_created <- graph$last_node

  # Extract the graph's ndf
  nodes <- get_node_df(graph)

  # Get column names from the graph's ndf
  column_names_graph <- colnames(nodes)

  # Stop function if `node_attr_from` is not one
  # of the graph's columns
  if (!any(column_names_graph %in% node_attr_from)) {

    cli::cli_abort(
      "The node attribute to rename is not in the ndf.")
  }

  # Set the column name for the renamed attr
  colnames(nodes)[
    which(colnames(nodes) %in%
            node_attr_from)] <- node_attr_to

  # Modify the graph's ndf
  graph$nodes_df <- nodes

  # Update the `last_node` counter
  graph$last_node <- nodes_created

  # Get the name of the function
  fcn_name <- get_calling_fcn()

  # Update the `graph_log` df with an action
  graph$graph_log <-
    add_action_to_log(
      graph_log = graph$graph_log,
      version_id = nrow(graph$graph_log) + 1L,
      function_used = fcn_name,
      time_modified = time_function_start,
      duration = graph_function_duration(time_function_start),
      nodes = nrow(graph$nodes_df),
      edges = nrow(graph$edges_df))

  # Write graph backup if the option is set
  if (graph$graph_info$write_backups) {
    save_graph_as_rds(graph = graph)
  }

  graph
}
