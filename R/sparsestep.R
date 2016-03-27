#' @title Fits the SparseStep model
#'
#' @description Fits the SparseStep model for a single value of the 
#' regularization parameter.
#'
#' @param x matrix of predictors
#' @param y response
#' @param lambda regularization parameter
#' @param gamma0 starting value of the gamma parameter
#' @param gammastop stopping value of the gamma parameter
#' @param IMsteps number of steps of the majorization algorithm to perform for 
#' each value of gamma
#' @param gammastep factor to decrease gamma with at each step
#' @param normalize if TRUE, each variable is standardized to have unit L2 
#' norm, otherwise it is left alone.
#' @param intercept if TRUE, an intercept is included in the model (and not 
#' penalized), otherwise no intercept is included
#' @param force.zero if TRUE, absolute coefficients smaller than the provided 
#' threshold value are set to absolute zero as a post-processing step, 
#' otherwise no thresholding is performed
#' @param threshold threshold value to use for setting coefficients to 
#' absolute zero
#' @param XX The X'X matrix; useful for repeated runs where X'X stays the same
#' @param Xy The X'y matrix; useful for repeated runs where X'y stays the same
#' @param use.XX whether or not to compute X'X and return it (boolean)
#' @param use.Xy whether or not to compute X'y and return it (boolean)
#'
#' @return A "sparsestep" S3 object is returned, for which print, predict, 
#' coef, and plot methods exist. It has the following items:
#' \item{call}{The call that was used to construct the model.}
#' \item{lambda}{The value(s) of lambda used to construct the model.}
#' \item{gamma0}{The gamma0 value of the model.}
#' \item{gammastop}{The gammastop value of the model}
#' \item{IMsteps}{The IMsteps value of the model}
#' \item{gammastep}{The gammastep value of the model}
#' \item{intercept}{Boolean indicating if an intercept was fitted in the 
#' model}
#' \item{force.zero}{Boolean indicating if a force zero-setting was 
#' performed.}
#' \item{threshold}{The threshold used for a forced zero-setting}
#' \item{beta}{The resulting coefficients stored in a sparse matrix format 
#' (dgCMatrix). This matrix has dimensions nvar x nlambda}
#' \item{a0}{The intercept vector for each value of gamma of length nlambda}
#' \item{normx}{Vector used to normalize the columns of x}
#' \item{meanx}{Vector of column means of x}
#' \item{XX}{The matrix X'X if use.XX was set to TRUE}
#' \item{Xy}{The matrix X'y if use.Xy was set to TRUE}
#'
#' @seealso
#' \code{\link{coef}}, \code{\link{print}}, \code{\link{predict}}, 
#' \code{\link{plot}}, and \code{\link{path.sparsestep}}.
#'
#' @export
#'
#' @examples
#' x <- matrix(rnorm(100*20), 100, 20)
#' y <- rnorm(100)
#' fit <- sparsestep(x, y)
#'
sparsestep <- function(x, y, lambda=c(0.1, 0.5, 1.0, 5, 10), gamma0=1e3,
		       gammastop=1e-4, IMsteps=2, gammastep=2.0,
		       normalize=TRUE, intercept=TRUE, force.zero=TRUE,
		       threshold=1e-7, XX=NULL, Xy=NULL, use.XX = TRUE,
		       use.Xy = TRUE)
{
	call <- match.call()
	prep <- preprocess(x, y, normalize, intercept, XX, Xy, use.XX, use.Xy)

	betas <- NULL
	for (lmd in lambda) {
		beta <- run.sparsestep(prep$x, prep$y, prep$XX, prep$Xy,
				       prep$nvars, lmd, gamma0, gammastep,
				       gammastop, IMsteps, force.zero,
				       threshold)
		betas <- cbind(betas, beta)
	}

	post <- postprocess(t(betas), prep$a0, prep$x, prep$normx, prep$nvars,
			    length(lambda))

	object <- list(call = call, lambda = lambda, gamma0 = gamma0,
		       gammastop = gammastop, IMsteps = IMsteps,
		       gammastep = gammastep, intercept = intercept,
		       force.zero = force.zero, threshold = threshold,
		       beta = post$beta, a0 = post$a0, normx = prep$normx,
		       meanx = prep$meanx, XX = if(use.XX) prep$XX else NULL,
		       Xy = if(use.Xy) prep$Xy else NULL)
	class(object) <- "sparsestep"
	return(object)
}
