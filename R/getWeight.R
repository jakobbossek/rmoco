#' Get the overall costs/weight of a subgraph given its edgelist.
#'
#' @template arg_grapherator
#' @template arg_edgelist
#' @param obj.types [\code{character}]\cr
#'   How to aggregate edge weights?
#'   Possible values are \dQuote{sum} for sum objective and \dQuote{bottleneck}
#'   for bottleneck/min-max objectives.
#'   Default is \dQuote{sum} for each objective.
#' @return [\code{numeric(2)}] Weight vector.
#' @examples
#' # generate a random bi-objective graph
#' g = genRandomMCGP(5)
#'
#' # generate a random Pruefer code, i.e., a random spanning tree of g
#' pcode = sample(1:5, 3, replace = TRUE)
#'
#' getWeight(g, prueferToEdgeList(pcode))
#' getWeight(g, prueferToEdgeList(pcode), obj.types = "bottleneck")
#' @export
getWeight = function(graph, edgelist, obj.types = NULL) {
  assertClass(graph, "grapherator")
  assertMatrix(edgelist)
  m = ncol(edgelist)

  n.weights = grapherator::getNumberOfWeights(graph)

  if (is.null(obj.types))
    obj.types = rep("sum", n.weights)
  if (length(obj.types) == 1L)
    obj.types = rep(obj.types, n.weights)

  # get edge weights (one column for each weight)
  edge.weights = getWeights(graph, edgelist)
  obj.vec = numeric(n.weights)
  for (i in 1:n.weights) {
    obj.vec[i] = if (obj.types[i] == "sum")
      sum(edge.weights[i, ])
    else
      max(edge.weights[i, ])
  }
  return(obj.vec)
}


getWeights = function(graph, edgelist) {
  assertClass(graph, "grapherator")
  assertMatrix(edgelist)
  m = ncol(edgelist)

  n.weights = grapherator::getNumberOfWeights(graph)

  # finally compute weights
  ws = matrix(NA, ncol = m, nrow = n.weights)

  #FIXME: inefficient
  for (i in seq_len(m)) {
    for (j in seq_len(n.weights)) {
      ws[j, i] = graph$weights[[j]][edgelist[1L, i], edgelist[2L, i]]
    }
  }
  return(ws)
}
