#' Convert a DiagrammeR graph to an igraph one
#'
#' @description
#'
#' Convert a DiagrammeR graph to an igraph graph object.
#'
#' @inheritParams render_graph
#'
#' @return An igraph object.
#'
#' @examples
#' # Create a random graph using the
#' # `add_gnm_graph()` function
#' graph <-
#'   create_graph() %>%
#'   add_gnm_graph(
#'     n = 36,
#'     m = 50,
#'     set_seed = 23)
#'
#' # Confirm that `graph` is a
#' # DiagrammeR graph by getting
#' # the object's class
#' class(graph)
#'
#' # Convert the DiagrammeR graph
#' # to an igraph object
#' ig_graph <- to_igraph(graph)
#'
#' # Get the class of the converted
#' # graph, just to be certain
#' class(ig_graph)
#'
#' # Get a summary of the igraph
#' # graph object
#' summary(ig_graph)
#'
#' @export
to_igraph <- function(graph) {

  # Validation: Graph object is valid
  check_graph_valid(graph)

  # Extract the graph's node data frame
  ndf <- graph$nodes_df

  # Extract the graph's edge data frame and
  # exclude the `id` column
  edf <-
    graph$edges_df %>%
    dplyr::select(-"id")

  igraph::graph_from_data_frame(
    d = edf,
    directed = graph$directed,
    vertices = ndf)
}
