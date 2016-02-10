#' @title Get the coefficients of a fitted SparseStep model
#'
#' @description Returns the coefficients of the SparseStep model.
#'
#' @param obj a "sparsestep" object
#'
#' @return The coefficients of the SparseStep model (i.e. the betas). If the
#' model was fitted with an intercept this will be the first value in the
#' resulting vector.
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
coef.sparsestep <- function(obj, ...)
{
  if (obj$intercept) {
    beta <- rbind(obj$a0, obj$beta)
  } else {
    beta <- obj$beta
  }
  nbeta <- drop0(Matrix(as.matrix(beta)))

  return(nbeta)
}
