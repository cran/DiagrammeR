#' Is the edge a multiple edge?
#'
#' @description
#'
#' Determines whether an edge definition has multiple edge IDs associated with
#' the same node pair.
#'
#' @inheritParams render_graph
#' @param edge A numeric edge ID value.
#'
#' @return A logical value.
#'
#' @examples
#' # Create a graph that has multiple
#' # edges across some node pairs
#' graph <-
#'   create_graph() %>%
#'   add_path(n = 4) %>%
#'   add_edge(
#'     from = 1,
#'     to = 2) %>%
#'   add_edge(
#'     from = 3,
#'     to = 4)
#'
#' # Get the graph's internal
#' # edge data frame
#' graph %>% get_edge_df()
#'
#' # Determine if edge `1` is
#' # a multiple edge
#' graph %>%
#'   is_edge_multiple(edge = 1)
#'
#' # Determine if edge `2` is
#' # a multiple edge
#' graph %>%
#'   is_edge_multiple(edge = 2)
#'
#' @export
is_edge_multiple <- function(
    graph,
    edge
) {

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Validation: Graph contains edges
  check_graph_contains_edges(graph)

  # Stop function if `edge` ID is not a single numeric
  # possible number_whole?
  check_number_decimal(edge)

  # Obtain the graph's edf
  edf <- graph$edges_df

  # Stop function if the edge ID provided
  # is not a valid edge ID
  if (!(edge %in% edf$id)) {

    cli::cli_abort(
      "The provided edge ID ({edge}) is not present in the graph.")
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

  # Determine if there are mulitple rows
  # where the definition of `from` and `to`
  # is valid
  multiple_edges <-
    edf %>%
    dplyr::filter(from == !!from, to == !!to)

  res <- nrow(multiple_edges) > 1
  res
}
