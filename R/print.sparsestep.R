#' @title Print the fitted SparseStep model
#'
#' @description Prints a short text of a fitted SparseStep model
#'
#' @param obj a "sparsestep" object to print
#'
#' @export
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
	cat("R-squared:", format(round(rev(obj$R2)[1], 3)), "\n")
	zeros <- length(which(obj$beta == 0))/length(obj$beta)*100.0
	cat("Percentage coeff zero:", format(round(zeros, 2)), "\n")
	invisible(obj)
}
