#' @title Print the fitted SparseStep model
#'
#' @description Prints a short text of a fitted SparseStep model
#'
#' @param x a \code{sparsestep} object to print
#' @param \dots further argument are ignored
#'
#' @author
#' Gerrit J.J. van den Burg, Patrick J.F. Groenen, Andreas Alfons\cr
#' Maintainer: Gerrit J.J. van den Burg <gertjanvandenburg@gmail.com>
#'
#' @references
#' Van den Burg, G.J.J., Groenen, P.J.F. and Alfons, A. (2017).
#'  \emph{SparseStep: Approximating the Counting Norm for Sparse Regularization},
#'  arXiv preprint arXiv:1701.06967 [stat.ME]. 
#'  URL \url{https://arxiv.org/abs/1701.06967}.
#'
#' @method print sparsestep
#' @export
#'
#' @examples
#' x <- matrix(rnorm(100*20), 100, 20)
#' y <- rnorm(100)
#' fit <- sparsestep(x, y)
#' print(fit)
#'
print.sparsestep <- function(x, ...)
{
	cat("\nCall:\n")
	dput(x$call)
	cat("Lambda:", x$lambda, "\n")
	invisible(x)
}
