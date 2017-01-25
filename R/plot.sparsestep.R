#' @title Plot the SparseStep path
#'
#' @description Plot the coefficients of the SparseStep path
#'
#' @param x a \code{sparsestep} object
#' @param \dots further argument to matplot
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
