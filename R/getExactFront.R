#' @title Enumerate all Pareto-optimal solutions.
#'
#' @description Function which expects an problem instance of a combinatorial optimization
#' problem (e.g., TSP), an multi-objective function and a solution enumerator, i.e., a function
#' which enumerates all possible solutions (e.g., all permutations in case of a
#' TSP problem) and  determines both the Pareto front and Pareto set by
#' exhaustive enumeration.
#'
#' @note This method exhaustively enumerates all possible solutions
#' of a given multi-objective combinatorial optimization problem. Thus,
#' it is limited to small input size due to combinatorial explosion.
#'
#' @param instance [any]\cr
#'   Problem instance.
#' @param obj.fun [\code{function(solution, instance)}]\cr
#'   Objective function which expects a numeric vector \code{solution} encoding a
#'   solution candidate and a problem instance \code{instance}. The function should
#'   return a numeric vector of length \code{n.objectives}.
#' @param enumerator.fun [\code{function(n)}]\cr
#'   Function to exhaustively generate all possible candidate solutions.
#'   Expects a single integer value n, i.e., the instance size, e.g., the
#'   number of nodes for a graph problem.
#' @param n.objectives [\code{integer(1)}]\cr
#'   Number of objectives of problem.
#' @return [\code{list}] List with elements \code{pareto.set} (matrix of Pareto-optimal solutions)
#' and \code{pareto.front} (matrix of weight vectors).
#' @export
getExactFront = function(instance, obj.fun, enumerator.fun, n.objectives) {
  assertFunction(obj.fun)
  assertFunction(enumerator.fun, args = "n")
  n.objectives = asInt(n.objectives, lower = 2L)

  n = instance$n
  if (n > 10L)
    warningf("Doh! This may take some time.")

  # allocate really large vector of permutations
  pp = enumerator.fun(n)
  n.sols = nrow(pp)
  len.sol = ncol(pp)

  pareto.set = matrix(ncol = len.sol, nrow = 0L)
  pareto.front = matrix(nrow = n.objectives, ncol = 0L)

  n.step = 1000L

  # now perform kind of a sliding window approach. This is done to avoid doing
  # non-domination check for n^(n-2) elements.
  i = 1L
  while (i < n.sols) {
    j = min(i + n.step, n.sols)
    weights = apply(pp[i:j, , drop = FALSE], 1L, obj.fun, instance)

    pareto.set = rbind(pareto.set, pp[i:j, , drop = FALSE])
    pareto.front = cbind(pareto.front, weights)

    idx.nondom = ecr::which.nondominated(pareto.front)
    pareto.set = pareto.set[idx.nondom, , drop = FALSE]
    pareto.front = pareto.front[, idx.nondom, drop = FALSE]
    i = j + 1L
  }

  return(list(pareto.set = pareto.set, pareto.front = pareto.front))
}