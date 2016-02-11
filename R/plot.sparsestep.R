#' @title Plot the SparseStep path
#'
#' @description Plot the coefficients of the SparseStep path
#'
#' @param x a \code{sparsestep} object
#' @param \dots further argument to matplot
#'
#' @export
#' @aliases plot
#'
#' @examples
#' x <- matrix(rnorm(100*20), 100, 20)
#' y <- rnorm(100)
#' fit <- sparsestep(x, y)
#' plot(fit)
#' pth <- path.sparsestep(x, y)
#' plot(pth)
plot.sparsestep <- function(x, ...)
{
	index <- log(x$lambda)
	coefs <- t(as.matrix(x$beta))

	dotlist <- list(...)
	type <- ifelse(is.null(dotlist$type), "s", dotlist$type)
	lty <- ifelse(is.null(dotlist$lty), 1, dotlist$lty)
	matplot(index, coefs, xlab="Log lambda", ylab="Coefficients",
		type=type, lty=lty, ...)
}
