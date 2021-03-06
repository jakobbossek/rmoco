#' @title Generate a bi-criteria graph with two uniformly randomly distribted edge weights.
#'
#' @description The instance is composed of two
#' symmetric weight matrices. The first weight is drawn independently at
#' random from a \eqn{\mathcal{R}[10, 100]} distribution, the second one
#' from a \eqn{\mathcal{R}[10, 50]} distribution (see references).
#'
#' @note This is a simple wrapper around the much more flexible graph generation
#' system in package \pkg{grapherator}.
#'
#' @references
#' Zhou, G. and Gen, M. Genetic Algorithm Approach on Multi-Criteria
#' Minimum Spanning Tree Problem. In: European Journal of Operational Research (1999).
#'
#' Knowles, JD & Corne, DW 2001, A comparison of encodings and algorithms for multiobjective
#' minimum spanning tree problems. in Proceedings of the IEEE Conference on Evolutionary
#' Computation, ICEC|Proc IEEE Conf Evol Comput Proc ICEC. vol. 1, Institute of Electrical
#' and Electronics Engineers , pp. 544-551, Congress on Evolutionary Computation 2001,
#' Soul, 1 July.
#'
#' @param n [\code{integer(1)}]\cr
#'   Instance size, i.e., number of nodes.
#' @template ret_grapherator
#' @examples
#' g = genRandomMCGP(10L)
#' \dontrun{
#' pl = grapherator::plot(g)
#' }
#' @export
genRandomMCGP = function(n) {
  n = asInt(n, lower = 2L)
  g = grapherator::graph(lower = 0, upper = 100)
  g = grapherator::addNodes(g, n = n, generator = grapherator::addNodesUniform)
  g = grapherator::addWeights(g, generator = grapherator::addWeightsRandom, method = runif, symmetric = TRUE, min = 10, max = 100, to.int = TRUE)
  g = grapherator::addWeights(g, generator = grapherator::addWeightsRandom, method = runif, symmetric = TRUE, min = 10, max = 50, to.int = TRUE)
  return(g)
}
