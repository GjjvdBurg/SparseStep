#' @title Plot the SparseStep path
#'
#' @description Plot the coefficients of the SparseStep path
#'
#' @param obj a \code{sparsestep} object
#' @param type the plot type, default: "s".
#' @param lty line type, default: 1
#' @param ... further argument to matplot
#'
#' @author
#' Gertjan van den Burg (author and maintainer).
#'
#' @export
#' @aliases plot
#'
#' @examples
#' data(diabetes)
#' attach(diabetes)
#' fit <- sparsestep(x, y)
#' plot(fit)
#' pth <- sparsestep.path(x, y)
#' plot(pth)
plot.sparsestep <- function(obj, type="s", lty=1, ...)
{
	index <- log(obj$lambda)
	coefs <- t(as.matrix(obj$beta))

	matplot(index, coefs, xlab="Log lambda", ylab="Coefficients",
	       	type=type, lty=lty, ...)
}
