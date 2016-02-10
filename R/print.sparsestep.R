#' @title Print the fitted SparseStep model
#'
#' @description Prints a short text of a fitted SparseStep model
#'
#' @param obj a "sparsestep" object to print
#'
#' @export
#'
#' @aliases print
#'
#' @examples
#' data(diabetes)
#' attach(diabetes)
#' object <- sparsestep(x, y)
#' print(object)
#' detach(diabetes)
#'
print.sparsestep <- function(obj, ...)
{
	cat("\nCall:\n")
	dput(obj$call)
	cat("Lambda:", obj$lambda, "\n")
	invisible(obj)
}
