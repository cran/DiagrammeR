% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_node_attrs_ws.R
\name{get_node_attrs_ws}
\alias{get_node_attrs_ws}
\title{Get node attribute values from a selection of nodes}
\usage{
get_node_attrs_ws(graph, node_attr)
}
\arguments{
\item{graph}{A graph object of class \code{dgr_graph}.}

\item{node_attr}{The name of the attribute for which to get values.}
}
\value{
A named vector of node attribute values for the attribute given by
\code{node_attr} by node ID.
}
\description{
From a graph object of class \code{dgr_graph}, get node attribute values from
nodes currently active as a selection.

This function makes use of an active selection of nodes (and the function
ending with \verb{_ws} hints at this).

Selections of nodes can be performed using the following node selection
(\verb{select_*()}) functions: \code{\link[=select_nodes]{select_nodes()}}, \code{\link[=select_last_nodes_created]{select_last_nodes_created()}},
\code{\link[=select_nodes_by_degree]{select_nodes_by_degree()}}, \code{\link[=select_nodes_by_id]{select_nodes_by_id()}}, or
\code{\link[=select_nodes_in_neighborhood]{select_nodes_in_neighborhood()}}.

Selections of nodes can also be performed using the following traversal
(\verb{trav_*()}) functions: \code{\link[=trav_out]{trav_out()}}, \code{\link[=trav_in]{trav_in()}}, \code{\link[=trav_both]{trav_both()}},
\code{\link[=trav_out_node]{trav_out_node()}}, \code{\link[=trav_in_node]{trav_in_node()}}, \code{\link[=trav_out_until]{trav_out_until()}}, or
\code{\link[=trav_in_until]{trav_in_until()}}.
}
\examples{
# Create a random graph using the
# `add_gnm_graph()` function
graph <-
  create_graph() \%>\%
  add_gnm_graph(
    n = 4,
    m = 4,
    set_seed = 23) \%>\%
  set_node_attrs(
    node_attr = value,
    values = c(2.5, 8.2, 4.2, 2.4))

# Select nodes with ID values
# `1` and `3`
graph <-
  graph \%>\%
  select_nodes_by_id(
    nodes = c(1, 3))

# Get the node attribute values
# for the `value` attribute, limited
# to the current node selection
graph \%>\%
  get_node_attrs_ws(
    node_attr = value)

}
