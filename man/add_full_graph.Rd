% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_full_graph.R
\name{add_full_graph}
\alias{add_full_graph}
\title{Add a fully connected graph}
\usage{
add_full_graph(
  graph,
  n,
  type = NULL,
  label = TRUE,
  rel = NULL,
  edge_wt_matrix = NULL,
  keep_loops = FALSE,
  node_aes = NULL,
  edge_aes = NULL,
  node_data = NULL,
  edge_data = NULL
)
}
\arguments{
\item{graph}{A graph object of class \code{dgr_graph}.}

\item{n}{The number of nodes comprising the fully connected graph.}

\item{type}{An optional string that describes the entity type for the nodes
to be added.}

\item{label}{Either a vector object of length \code{n} that provides optional
labels for the new nodes, or, a boolean value where setting to \code{TRUE}
ascribes node IDs to the label and \code{FALSE} or \code{NULL} yields a blank label.}

\item{rel}{An optional string for providing a relationship label to all new
edges created in the connected graph.}

\item{edge_wt_matrix}{An optional matrix of \code{n} by \code{n} dimensions containing
values to apply as edge weights. If the matrix has row names or column
names and \code{label = TRUE}, those row or column names will be used as node
label values.}

\item{keep_loops}{An option to simplify the fully connected graph by removing
loops (edges from and to the same node). The default value is \code{FALSE}.}

\item{node_aes}{An optional list of named vectors comprising node aesthetic
attributes. The helper function \code{\link[=node_aes]{node_aes()}} is strongly recommended for
use here as it contains arguments for each of the accepted node aesthetic
attributes (e.g., \code{shape}, \code{style}, \code{color}, \code{fillcolor}).}

\item{edge_aes}{An optional list of named vectors comprising edge aesthetic
attributes. The helper function \code{\link[=edge_aes]{edge_aes()}} is strongly recommended for
use here as it contains arguments for each of the accepted edge aesthetic
attributes (e.g., \code{shape}, \code{style}, \code{penwidth}, \code{color}).}

\item{node_data}{An optional list of named vectors comprising node data
attributes. The helper function \code{\link[=node_data]{node_data()}} is strongly recommended for
use here as it helps bind data specifically to the created nodes.}

\item{edge_data}{An optional list of named vectors comprising edge data
attributes. The helper function \code{\link[=edge_data]{edge_data()}} is strongly recommended for
use here as it helps bind data specifically to the created edges.}
}
\value{
A graph object of class \code{dgr_graph}.
}
\description{
With a graph object of class \code{dgr_graph}, add a fully connected graph either
with or without loops. If the graph object set as directed, the added graph
will have edges to and from each pair of nodes. In the undirected case, a
single edge will link each pair of nodes.
}
\examples{
# Create a new graph object
# and add a directed and fully
# connected graph with 3 nodes
# and edges to and from all
# pairs of nodes; with the option
# `keep_loops = TRUE` nodes
# will also have edges from
# and to themselves
graph <-
  create_graph() \%>\%
  add_full_graph(
    n = 3, keep_loops = TRUE
  )

# Get node information
# from this graph
graph \%>\% get_node_info()

# Using `keep_loops = FALSE`
# (the default) will remove
# the loops
create_graph() \%>\%
  add_full_graph(n = 3) \%>\%
  get_node_info()

# Values can be set for
# the node `label`, node
# `type`, and edge `rel`
graph <-
  create_graph() \%>\%
  add_full_graph(
    n = 3,
    type = "connected",
    label = c("1st", "2nd", "3rd"),
    rel = "connected_to"
  )

# Show the graph's node
# data frame (ndf)
graph \%>\% get_node_df()

# Show the graph's edge
# data frame (edf)
graph \%>\% get_edge_df()

# Create a fully-connected and
# directed graph with 3 nodes,
# and, where a matrix provides
# edge weights; first, create the
# matrix (with row names to be
# used as node labels)
suppressWarnings(RNGversion("3.5.0"))
set.seed(23)

edge_wt_matrix <-
  rnorm(100, 5, 2) \%>\%
  sample(9, FALSE) \%>\%
  round(2) \%>\%
  matrix(
    ncol = 3,
    nrow = 3,
    dimnames = list(c("a", "b", "c"))
  )

# Create the fully-connected
# graph (without loops however)
graph <-
  create_graph() \%>\%
  add_full_graph(
    n = 3,
    type = "weighted",
    label = TRUE,
    rel = "related_to",
    edge_wt_matrix = edge_wt_matrix,
    keep_loops = FALSE
  )

# Show the graph's node
# data frame (ndf)
graph \%>\% get_node_df()

# Show the graph's edge
# data frame (edf)
graph \%>\% get_edge_df()

# An undirected graph can
# also use a matrix with
# edge weights, but only
# the lower triangle of
# that matrix will be used
create_graph(directed = FALSE) \%>\%
  add_full_graph(
    n = 3,
    type = "weighted",
    label = TRUE,
    rel = "related_to",
    edge_wt_matrix = edge_wt_matrix,
    keep_loops = FALSE
  ) \%>\%
  get_edge_df()

}
