#' Add an edge between nodes in a graph object
#'
#' @description
#'
#' With a graph object of class `dgr_graph`, add an edge to nodes within the
#' graph.
#'
#' @inheritParams node_edge_aes_data
#' @inheritParams render_graph
#' @param from The outgoing node from which the edge is connected. There is the
#'   option to use a node `label` value here (and this must correspondingly also
#'   be done for the `to` argument) for defining node connections. Note that
#'   this is only possible if all nodes have distinct `label` values set and
#'   none exist as an empty string.
#' @param to The incoming nodes to which each edge is connected. There is the
#'   option to use a node `label` value here (and this must correspondingly also
#'   be done for the `from` argument) for defining node connections. Note that
#'   this is only possible if all nodes have distinct `label` values set and
#'   none exist as an empty string.
#' @param rel An optional string specifying the relationship between the
#'   connected nodes.
#'
#' @return A graph object of class `dgr_graph`.
#'
#' @examples
#' # Create a graph with 4 nodes
#' graph <-
#'   create_graph() %>%
#'   add_node(label = "one") %>%
#'   add_node(label = "two") %>%
#'   add_node(label = "three") %>%
#'   add_node(label = "four")
#'
#' # Add an edge between those
#' # nodes and attach a
#' # relationship to the edge
#' graph <-
#'  add_edge(
#'    graph,
#'    from = 1,
#'    to = 2,
#'    rel = "A")
#'
#' # Use the `get_edge_info()`
#' # function to verify that
#' # the edge has been created
#' graph %>%
#'   get_edge_info()
#'
#' # Add another node and
#' # edge to the graph
#' graph <-
#'   graph %>%
#'   add_edge(
#'     from = 3,
#'     to = 2,
#'     rel = "A")
#'
#' # Verify that the edge
#' # has been created by
#' # counting graph edges
#' graph %>% count_edges()
#'
#' # Add edges by specifying
#' # node `label` values; note
#' # that all nodes must have
#' # unique `label` values to
#' # use this option
#' graph <-
#'   graph %>%
#'   add_edge(
#'     from = "three",
#'     to = "four",
#'     rel = "L") %>%
#'   add_edge(
#'     from = "four",
#'     to = "one",
#'     rel = "L")
#'
#' # Use `get_edges()` to verify
#' # that the edges were added
#' graph %>% get_edges()
#'
#' # Add edge aesthetic and data
#' # attributes during edge creation
#' graph_2 <-
#'   create_graph() %>%
#'   add_n_nodes(n = 2) %>%
#'   add_edge(
#'     from = 1,
#'     to = 2,
#'     rel = "M",
#'     edge_aes = edge_aes(
#'       penwidth = 1.5,
#'       color = "blue"),
#'     edge_data = edge_data(
#'       value = 4.3))
#'
#' # Use the `get_edges()` function
#' # to verify that the attribute
#' # values were bound to the
#' # newly created edge
#' graph_2 %>% get_edge_df()
#'
#'
#' @family edge creation and removal
#'
#' @export
add_edge <- function(
    graph,
    from,
    to,
    rel = NULL,
    edge_aes = NULL,
    edge_data = NULL
) {

  # Get the time of function start
  time_function_start <- Sys.time()

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Validation: Graph contains nodes
  check_graph_contains_nodes(graph, extra_msg = "An edge cannot be added.")

  if (length(from) > 1 || length(to) > 1) {

    rlang::abort("Only one edge can be specified in `from` or `to`")
  }

  # Get the value for the latest `version_id` for
  # graph (in the `graph_log`)
  current_graph_log_version_id <-
    max(graph$graph_log$version_id)

  rel <- rel %||% NA_character_

  # Collect edge aesthetic attributes
  if (!is.null(edge_aes)) {

    edge_aes_tbl <- dplyr::as_tibble(edge_aes)

    if (nrow(edge_aes_tbl) == 1) {

      edge_aes$index__ <- 1

      edge_aes_tbl <-
        dplyr::as_tibble(edge_aes) %>%
        dplyr::select(-"index__")
    }

    if ("id" %in% colnames(edge_aes_tbl)) {
      edge_aes_tbl$id <- NULL
    }
  }

  # Collect edge data attributes
  if (!is.null(edge_data)) {

    edge_data_tbl <- dplyr::as_tibble(edge_data)

    if (nrow(edge_data_tbl) == 1) {

      edge_data$index__ <- 1

      edge_data_tbl <-
        dplyr::as_tibble(edge_data) %>%
        dplyr::select(-"index__")
    }

    if ("id" %in% colnames(edge_data_tbl)) {
      edge_data_tbl$id <- NULL
    }
  }

  # If `from` and `to` values provided as character
  # values, assume that these values refer to node
  # `label` attr values
  if (is.character(from) && is.character(to)) {

    # Stop function if the label for
    # `from` does not exist in the graph
    if (!(from %in% graph$nodes_df$label)) {

      rlang::abort(
        "The value provided in `from` does not exist as a node `label` value.")
    }

    # Stop function if the label for
    # `from` is not distinct in the graph
    if (graph$nodes_df %>%
        dplyr::select("label") %>%
        dplyr::filter(label == from) %>%
        nrow() > 1) {

      rlang::abort(
         "The node `label` provided in `from` is not distinct in the graph.")
    }

    # Stop function if the label for
    # `to` does not exist in the graph
    if (!(to %in% graph$nodes_df$label)) {

      rlang::abort(
        "The value provided in `to` does not exist as a node `label` value.")
    }

    # Stop function if the label for
    # `to` is not distinct in the graph
    if (graph$nodes_df %>%
        dplyr::select("label") %>%
        dplyr::filter(label == to) %>%
        nrow() > 1) {

      rlang::abort(
        "The node `label` provided in `to` is not distinct in the graph.")
    }

    # Use the `translate_to_node_id()` helper function to map
    # node `label` values to node `id` values
    from_to_node_id <-
      translate_to_node_id(
        graph = graph,
        from = from,
        to = to)

    from <- from_to_node_id$from
    to <- from_to_node_id$to
  }

  # Use `bind_rows()` to add an edge
  if (!is.null(graph$edges_df)) {

    combined_edges <-
      dplyr::bind_rows(
        graph$edges_df,
        data.frame(
          id = as.integer(graph$last_edge + 1),
          from = as.integer(from),
          to = as.integer(to),
          rel = as.character(rel),
          stringsAsFactors = FALSE))

    # Use the `combined_edges` object as a
    # replacement for the graph's internal
    # edge data frame
    graph$edges_df <- combined_edges

    if (exists("edge_aes_tbl")) {

      # If extra edge attributes available, add
      # those to the new edge
      graph <-
        suppressMessages(
          graph %>%
            select_edges_by_edge_id(
              edges = graph$edges_df$id %>% max())
        )

      # Iteratively set edge attribute values for
      # the new edge in the graph
      for (i in seq_len(ncol(edge_aes_tbl))) {
        graph <-
          graph %>%
          set_edge_attrs_ws(
            edge_attr = !!colnames(edge_aes_tbl)[i],
            value = edge_aes_tbl[1, i][[1]]
          )
      }

      # Clear the graph's active selection
      graph <-
        suppressMessages(
          clear_selection(graph))
    }

    if (exists("edge_data_tbl")) {

      # If extra edge attributes available, add
      # those to the new edge
      graph <-
        suppressMessages(
          graph %>%
            select_edges_by_edge_id(
              edges = max(graph$edges_df$id))
        )

      # Iteratively set edge attribute values for
      # the new edge in the graph
      for (i in seq_len(ncol(edge_data_tbl))) {
        graph <-
          graph %>%
          set_edge_attrs_ws(
            edge_attr = !!colnames(edge_data_tbl)[i],
            value = edge_data_tbl[1, i][[1]]
          )
      }

      # Clear the graph's active selection
      graph <-
        suppressMessages(
          clear_selection(graph))
    }

    # Modify the `last_edge` vector
    graph$last_edge <- as.integer(graph$last_edge + 1L)

    # Remove extra items from the `graph_log`
    graph$graph_log <-
      graph$graph_log %>%
      dplyr::filter(version_id <= current_graph_log_version_id)

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
        edges = nrow(graph$edges_df),
        d_e = 1)

    # Perform graph actions, if any are available
    if (nrow(graph$graph_actions) > 0) {
      graph <-
        trigger_graph_actions(graph)
    }

    # Write graph backup if the option is set
    if (graph$graph_info$write_backups) {
      save_graph_as_rds(graph = graph)
    }

    graph
  }
}
