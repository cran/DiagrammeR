#' Is the edge a loop edge?
#'
#' @description
#'
#' Determines whether an edge definition is a loop edge.
#'
#' @inheritParams render_graph
#' @param edge A numeric edge ID value.
#'
#' @return A logical value.
#'
#' @examples
#' # Create a graph that has multiple
#' # loop edges
#' graph <-
#'   create_graph() %>%
#'   add_path(n = 4) %>%
#'   add_edge(
#'     from = 1,
#'     to = 1) %>%
#'   add_edge(
#'     from = 3,
#'     to = 3)
#'
#' # Get the graph's internal
#' # edge data frame
#' graph %>% get_edge_df()
#'
#' # Determine if edge `4` is
#' # a loop edge
#' graph %>% is_edge_loop(edge = 4)
#'
#' # Determine if edge `2` is
#' # a loop edge
#' graph %>% is_edge_loop(edge = 2)
#'
#' @export
is_edge_loop <- function(
    graph,
    edge
) {

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Validation: Graph contains edges
  check_graph_contains_edges(graph)

  # Validation: Stop function if `edge` is not a single numeric value.
  check_number_decimal(edge)

  # Obtain the graph's edf
  edf <- graph$edges_df

  # Stop function if the edge ID provided
  # is not a valid edge ID
  if (!(edge %in% edf$id)) {

    cli::cli_abort(
      "The provided edge ID is not present in the graph.")
  }

  # Obtain the edge definition
  from <-
    edf %>%
    dplyr::filter(id == !!edge) %>%
    dplyr::pull("from")

  to <-
    edf %>%
    dplyr::filter(id == !!edge) %>%
    dplyr::pull("to")

  # If the `from` and `to` node IDs
  # are the same then this is a loop edge
  if (from == to) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
