#' @title Make predictions from a SparseStep model
#'
#' @description Predicts the outcome variable for the SparseStep model for 
#' each value of lambda supplied to the model.
#'
#' @param object Fitted "sparsestep" object
#' @param newx Matrix of new values for `x` at which predictions are to be made.
#' @param ... further argument are ignored
#'
#' @return a matrix of numerical predictions of size nobs x nlambda
#'
#' @export
#' @aliases predict
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
