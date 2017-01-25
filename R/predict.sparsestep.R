#' @title Make predictions from a SparseStep model
#'
#' @description Predicts the outcome variable for the SparseStep model for 
#' each value of lambda supplied to the model.
#'
#' @param object Fitted \code{sparsestep} object
#' @param newx Matrix of new values for \code{x} at which predictions are to 
#' be made.
#' @param \dots further argument are ignored
#'
#' @return a matrix of numerical predictions of size nobs x nlambda
#'
#' @export
#' @aliases predict
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
#' @examples
#' x <- matrix(rnorm(100*20), 100, 20)
#' y <- rnorm(100)
#' fit <- sparsestep(x, y)
#' yhat <- predict(fit, x)
#'
predict.sparsestep <- function(object, newx, ...)
{
  yhat <- newx %*% as.matrix(object$beta)
  if (object$intercept) {
	  yhat <- yhat + rep(1, nrow(yhat)) %*% object$a0
  }
  return(yhat)
}
