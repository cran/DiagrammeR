#' Traverse from one or more selected edges onto adjacent, inward nodes
#'
#' @description
#'
#' From a graph object of class `dgr_graph` with an active selection of edges
#' move with the edge direction to connected nodes, replacing the current edges
#' in the selection with those nodes traversed to. An optional filter by node
#' attribute can limit the set of nodes traversed to.
#'
#' This traversal function makes use of an active selection of edges. After the
#' traversal, depending on the traversal conditions, there will either be a
#' selection of nodes or no selection at all.
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
#' @param conditions An option to use filtering conditions for the traversal.
#' @param copy_attrs_from Providing an edge attribute name will copy those edge
#'   attribute values to the traversed nodes. If the edge attribute already
#'   exists, the values will be merged to the traversed nodes; otherwise, a new
#'   node attribute will be created.
#' @param copy_attrs_as If an edge attribute name is provided in
#'   `copy_attrs_from`, this option will allow the copied attribute values to be
#'   written under a different node attribute name. If the attribute name
#'   provided in `copy_attrs_as` does not exist in the graph's ndf, the new node
#'   attribute will be created with the chosen name.
#' @param agg If an edge attribute is provided to `copy_attrs_from`, then an
#'   aggregation function is required since there may be cases where multiple
#'   edge attribute values will be passed onto the traversed node(s). To pass
#'   only a single value, the following aggregation functions can be used:
#'   `sum`, `min`, `max`, `mean`, or `median`.
#'
#' @return A graph object of class `dgr_graph`.
#'
#' @examples
#' # Set a seed
#' suppressWarnings(RNGversion("3.5.0"))
#' set.seed(23)
#'
#' # Create a simple graph
#' graph <-
#'   create_graph() %>%
#'   add_n_nodes(
#'     n = 2,
#'     type = "a",
#'     label = c("asd", "iekd")) %>%
#'   add_n_nodes(
#'     n = 3,
#'     type = "b",
#'     label = c("idj", "edl", "ohd")) %>%
#'   add_edges_w_string(
#'     edges = "1->2 1->3 2->4 2->5 3->5",
#'     rel = c(NA, "A", "B", "C", "D"))
#'
#' # Create a data frame with node ID values
#' # representing the graph edges (with `from`
#' # and `to` columns), and, a set of numeric values
#' df_edges <-
#'   data.frame(
#'     from = c(1, 1, 2, 2, 3),
#'     to = c(2, 3, 4, 5, 5),
#'     values = round(rnorm(5, 5), 2))
#'
#' # Create a data frame with node ID values
#' # representing the graph nodes (with the `id`
#' # columns), and, a set of numeric values
#' df_nodes <-
#'   data.frame(
#'     id = 1:5,
#'     values = round(rnorm(5, 7), 2))
#'
#' # Join the data frame to the graph's internal
#' # edge data frame (edf)
#' graph <-
#'   graph %>%
#'   join_edge_attrs(df = df_edges) %>%
#'   join_node_attrs(df = df_nodes)
#'
#' # Show the graph's internal node data frame
#' graph %>% get_node_df()
#'
#' # Show the graph's internal edge data frame
#' graph %>% get_edge_df()
#'
#' # Perform a simple traversal from the
#' # edge `1`->`3` to the attached node
#' # in the direction of the edge; here, no
#' # conditions are placed on the nodes
#' # traversed to
#' graph %>%
#'   select_edges(
#'     from = 1,
#'     to = 3) %>%
#'   trav_in_node() %>%
#'   get_selection()
#'
#' # Traverse from edges `2`->`5` and
#' # `3`->`5` to the attached node along
#' # the direction of the edge; both
#' # traversals lead to the same node
#' graph %>%
#'   select_edges(
#'     from = 2,
#'     to = 5) %>%
#'   select_edges(
#'     from = 3,
#'     to = 5) %>%
#'   trav_in_node() %>%
#'   get_selection()
#'
#' # Traverse from the edge `1`->`3`
#' # to the attached node where the edge
#' # is incoming, this time filtering
#' # numeric values greater than `5.0` for
#' # the `values` node attribute
#' graph %>%
#'   select_edges(
#'     from = 1,
#'     to = 3) %>%
#'   trav_in_node(
#'     conditions = values > 5.0) %>%
#'   get_selection()
#'
#' # Traverse from the edge `1`->`3`
#' # to the attached node where the edge
#' # is incoming, this time filtering
#' # numeric values less than `5.0` for
#' # the `values` node attribute (the
#' # condition is not met so the original
#' # selection of edge `1` -> `3` remains)
#' graph %>%
#'   select_edges(
#'     from = 1,
#'     to = 3) %>%
#'   trav_in_node(
#'     conditions = values < 5.0) %>%
#'   get_selection()
#'
#' # Traverse from the edge `1`->`2` to
#' # the node `2` using multiple conditions
#' # with a single-length vector
#' graph %>%
#'   select_edges(
#'     from = 1,
#'     to = 2) %>%
#'   trav_in_node(
#'     conditions =
#'       grepl(".*d$", label) |
#'       values < 6.0) %>%
#'   get_selection()
#'
#' # Create another simple graph to demonstrate
#' # copying of edge attribute values to traversed
#' # nodes
#' graph <-
#'   create_graph() %>%
#'   add_node() %>%
#'   select_nodes() %>%
#'   add_n_nodes_ws(
#'     n = 2,
#'     direction = "to") %>%
#'   clear_selection() %>%
#'   select_nodes_by_id(nodes = 2) %>%
#'   set_node_attrs_ws(
#'     node_attr = value,
#'     value = 8) %>%
#'   clear_selection() %>%
#'   select_edges_by_edge_id(edges = 1) %>%
#'   set_edge_attrs_ws(
#'     edge_attr = value,
#'     value = 5) %>%
#'   clear_selection() %>%
#'   select_edges_by_edge_id(edges = 2) %>%
#'   set_edge_attrs_ws(
#'     edge_attr = value,
#'     value = 5) %>%
#'   clear_selection() %>%
#'   select_edges()
#'
#' # Show the graph's internal edge data frame
#' graph %>% get_edge_df()
#'
#' # Show the graph's internal node data frame
#' graph %>% get_node_df()
#'
#' # Perform a traversal from the edges to
#' # the central node (`1`) while also applying
#' # the edge attribute `value` to the node (in
#' # this case summing the `value` of 5 from
#' # both edges before adding as a node attribute)
#' graph <-
#'   graph %>%
#'   trav_in_node(
#'     copy_attrs_from = value,
#'     agg = "sum")
#'
#' # Show the graph's internal node data frame
#' # after this change
#' graph %>% get_node_df()
#'
#' @export
trav_in_node <- function(
    graph,
    conditions = NULL,
    copy_attrs_from = NULL,
    copy_attrs_as = NULL,
    agg = "sum"
) {

  # Get the time of function start
  time_function_start <- Sys.time()

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Validation: Graph contains nodes
  check_graph_contains_nodes(graph)

  # Validation: Graph contains edges
  check_graph_contains_edges(graph)

  # Validation: Graph object has valid edge selection
  check_graph_contains_edge_selection(
    graph,
    c("Any traversal requires an active selection.",
      "This type of traversal requires a selection of edges."))

  # Get the requested `copy_attrs_from`
  copy_attrs_from <-
    rlang::enquo(copy_attrs_from) %>% rlang::get_expr() %>% as.character()

  # Get the requested `copy_attrs_as`
  copy_attrs_as <-
    rlang::enquo(copy_attrs_as) %>% rlang::get_expr() %>% as.character()

  if (length(copy_attrs_from) == 0) {
    copy_attrs_from <- NULL
  }

  if (length(copy_attrs_as) == 0) {
    copy_attrs_as <- NULL
  }

  if (!is.null(copy_attrs_as) && !is.null(copy_attrs_from)) {
    if (copy_attrs_as == copy_attrs_from) {
      copy_attrs_as <- NULL
    }
  }

  # Get the selection of edges
  starting_edges <- graph$edge_selection

  # Get the graph's node data frame
  ndf <- graph$nodes_df

  # Get the graph's edge data frame
  edf <- graph$edges_df

  # Find all nodes that are connected to the
  # starting edges
  valid_nodes <-
    starting_edges %>%
    dplyr::distinct(to) %>%
    dplyr::left_join(ndf, by = c("to" = "id"))

  # If traversal conditions are provided then
  # pass in those conditions and filter the
  # data frame of `valid_nodes`
  if (!rlang::quo_is_null(rlang::enquo(conditions))) {

    valid_nodes <- dplyr::filter(.data = valid_nodes, {{ conditions }})
  }

  # If no rows returned, then there are no
  # valid traversals, so return the same graph
  # object without modifying the selection
  if (nrow(valid_nodes) == 0) {
    return(graph)
  }

  # If the option is taken to copy edge attribute
  # values to the traversed nodes, perform the join
  # operation
  if (!is.null(copy_attrs_from)) {

    nodes <-
      starting_edges %>%
      dplyr::semi_join(valid_nodes, by = "to") %>%
      dplyr::left_join(edf, by = c("edge" = "id")) %>%
      dplyr::select("to.y", !!enquo(copy_attrs_from))


    if (!is.null(copy_attrs_as)) {

      if (copy_attrs_as %in% c("id", "from", "to")) {

        cli::cli_abort(
          "Copied attributes should not overwrite either of the `id`, `from`, or `to` edge attributes.")
      }

      colnames(nodes)[2] <- copy_attrs_from <- copy_attrs_as
    }

    nodes <-
      nodes %>%
      dplyr::rename(id = to.y) %>%
      dplyr::group_by(id) %>%
      dplyr::summarize(!!copy_attrs_from :=
                         match.fun(!!agg)(!!as.name(copy_attrs_from),
                                           na.rm = TRUE)) %>%
      dplyr::right_join(ndf, by = "id") %>%
      dplyr::relocate("id", "type", "label") %>%
      as.data.frame(stringsAsFactors = FALSE)

    # If edge attribute exists as a column in the ndf
    if (copy_attrs_from %in% colnames(ndf)) {

      # Get column numbers that end with ".x" or ".y"
      split_var_x_col <-
        grep("\\.x$", colnames(nodes))

      split_var_y_col <-
        grep("\\.y$", colnames(nodes))

      # Selectively merge in values to the existing
      # edge attribute column
      for (i in seq_len(nrow(nodes))) {
        if (!is.na(nodes[i, split_var_x_col])) {
          nodes[i, split_var_y_col] <- nodes[i, split_var_x_col]
        }
      }

      # Rename the ".y" column
      colnames(nodes)[split_var_y_col] <- copy_attrs_from

      # Drop the ".x" column
      nodes <- nodes[-split_var_x_col]

      # Reorder columns
      nodes <-
        nodes %>%
        dplyr::relocate("id", "type", "label")
    }

    # Update the graph's internal node data frame
    graph$nodes_df <- nodes
  }

  # Add the node ID values to the active selection
  # of nodes in `graph$node_selection`
  graph$node_selection <-
    replace_graph_node_selection(
      graph = graph,
      replacement = valid_nodes$to)

  # Replace `graph$edge_selection` with an empty df
  graph$edge_selection <- create_empty_esdf()

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
