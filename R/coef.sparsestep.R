#' @title Get the coefficients of a fitted SparseStep model
#'
#' @description Returns the coefficients of the SparseStep model.
#'
#' @param object a \code{sparsestep} object
#' @param \dots further argument are ignored
#'
#' @return The coefficients of the SparseStep model (i.e. the betas). If the
#' model was fitted with an intercept this will be the first value in the
#' resulting vector.
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
#' @aliases coef
#'
#' @examples
#' x <- matrix(rnorm(100*20), 100, 20)
#' y <- rnorm(100)
#' fit <- sparsestep(x, y)
#' coef(fit)
#'
coef.sparsestep <- function(object, ...)
{
  if (object$intercept) {
    beta <- rbind(object$a0, object$beta)
  } else {
    beta <- object$beta
  }
  nbeta <- drop0(Matrix(as.matrix(beta)))

  return(nbeta)
}
