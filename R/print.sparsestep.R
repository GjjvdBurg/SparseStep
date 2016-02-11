#' @title Print the fitted SparseStep model
#'
#' @description Prints a short text of a fitted SparseStep model
#'
#' @param x a "sparsestep" object to print
#' @param ... further argument are ignored
#'
#' @export
#'
#' @aliases print
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
