#' @title Approximate path algorithm for the SparseStep model
#'
#' @description Fits the entire regularization path for SparseStep using a 
#' Golden Section search. Note that this algorithm is approximate, there is no 
#' guarantee that the solutions _between_ induced values of lambdas do not 
#' differ from those calculated. For instance, if solutions are calculated at 
#' \eqn{\lambda_{i}}{\lambda[i]} and \eqn{\lambda_{i+1}}{\lambda[i+1]}, this 
#' algorithm ensures that \eqn{\lambda_{i+1}}{\lambda[i+1]} has one more zero 
#' than the solution at \eqn{\lambda_{i}}{\lambda[i]} (provided the recursion 
#' depth is large enough). There is however no guarantee that there are no 
#' different solutions between \eqn{\lambda_{i}}{\lambda[i]} and 
#' \eqn{\lambda_{i+1}}{\lambda[i+1]}.  This is an ongoing research topic.
#'
#' Note that this path algorithm is not faster than running the 
#' \code{sparsestep} function with the same \eqn{\lambda} sequence.
#'
#' @param x matrix of predictors
#' @param y response
#' @param max.depth maximum recursion depth
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
#' @param use.XX whether or not to compute X'X and return it
#' @param use.Xy whether or not to compute X'y and return it
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
#' @export
#'
#' @seealso
#' \code{\link{coef}}, \code{\link{print}}, \code{\link{predict}}, 
#' \code{\link{plot}}, and \code{\link{sparsestep}}.
#'
#' @examples
#' x <- matrix(rnorm(100*20), 100, 20)
#' y <- rnorm(100)
#' pth <- path.sparsestep(x, y)
#'
path.sparsestep <- function(x, y, max.depth=10, gamma0=1e3, gammastop=1e-4,
			    IMsteps=2, gammastep=2.0, normalize=TRUE,
			    intercept=TRUE, force.zero=TRUE, threshold=1e-7,
			    XX=NULL, Xy=NULL, use.XX = TRUE, use.Xy = TRUE)
{
	call <- match.call()

	prep <- preprocess(x, y, normalize, intercept, XX, Xy, use.XX, use.Xy)
	nvars <- prep$nvars;
	XX <- prep$XX;
	Xy <- prep$Xy;

	iter <- 0

	# First find the smallest lambda for which all coefficients are zero
	lambda.max <- 2^25
	beta <- NULL
	while (1) {
		last.beta <- beta
		beta <- run.sparsestep(prep$x, prep$y, XX, Xy, nvars,
				       lambda.max, gamma0, gammastep,
				       gammastop, IMsteps, force.zero,
				       threshold)
		iter <- iter + 1
		if (all(beta == 0)) {
			lambda.max <- lambda.max / 2
		} else {
			lambda.max <- lambda.max * 2
			break
		}
	}
	cat("Found maximum value of lambda: 2^(", log(lambda.max)/log(2), ")\n")
	iter <- iter + 1
	if (is.null(last.beta)) {
		betas.max <- beta
	} else {
		betas.max <- last.beta
	}

	# Now find the largest lambda for which no coefficients are zero
	lambda.min <- 2^-12
	beta <- NULL
	while (1) {
		last.beta <- beta
		beta <- run.sparsestep(prep$x, prep$y, XX, Xy, nvars,
				       lambda.min, gamma0, gammastep,
				       gammastop, IMsteps, force.zero,
				       threshold)
		iter <- iter + 1
		if (all(beta != 0)) {
			lambda.min <- lambda.min * 2
		} else {
			lambda.min <- lambda.min / 2
			break
		}
	}
	cat("Found minimum value of lambda: 2^(", log(lambda.min)/log(2), ")\n")
	iter <- iter + 1
	if (is.null(last.beta)) {
		betas.min <- beta
	} else {
		betas.min <- last.beta
	}

	# Run binary section search
	have.zeros <- as.vector(matrix(FALSE, 1, nvars+1))
	have.zeros[1] <- TRUE
	have.zeros[nvars+1] <- TRUE

	left <- log(lambda.min)/log(2)
	right <- log(lambda.max)/log(2)

	l <- lambda.search(prep$x, prep$y, 0, max.depth, have.zeros, left,
			   right, 1, nvars+1, XX, Xy, gamma0, gammastep,
			   gammastop, IMsteps, force.zero, threshold)
	have.zeros <- have.zeros | l$have.zeros
	lambdas <- c(lambda.min, l$lambdas, lambda.max)
	betas <- t(cbind(betas.min, l$betas, betas.max))
	iter <- iter + l$iter

	ord <- order(lambdas)
	lambdas <- lambdas[ord]
	betas <- betas[ord, ]

	post <- postprocess(betas, prep$a0, prep$x, prep$normx, nvars,
			    length(lambdas))

	object <- list(call = call, lambda = lambdas, gamma0 = gamma0,
		       gammastop = gammastop, IMsteps = IMsteps,
		       gammastep = gammastep, intercept = intercept,
		       force.zero = force.zero, threshold = threshold,
		       beta = post$beta, a0 = post$a0, normx = prep$normx,
		       meanx = prep$meanx, XX = if(use.XX) XX else NULL,
		       Xy = if(use.Xy) Xy else NULL)
	class(object) <- "sparsestep"
	return(object)
}

lambda.search <- function(x, y, depth, max.depth, have.zeros, left, right,
			  lidx, ridx, XX, Xy, gamma0, gammastep, gammastop,
			   IMsteps, force.zero, threshold)
{
	cat("Running search in interval [", left, ",", right, "] ... \n")
	nvars <- dim(XX)[1]

	betas <- NULL
	lambdas <- NULL

	middle <- left + (right - left)/2
	lambda <- 2^middle
	beta <- run.sparsestep(x, y, XX, Xy, nvars, lambda, gamma0, gammastep,
			       gammastop, IMsteps, force.zero, threshold)
	iter <- 1

	num.zero <- length(which(beta == 0))
	cidx <- num.zero + 1
	if (have.zeros[cidx] == FALSE) {
		have.zeros[cidx] = TRUE
		betas <- cbind(betas, beta)
		lambdas <- c(lambdas, lambda)
	}

	idx <- rbind(c(lidx, cidx), c(cidx, ridx))
	bnd <- rbind(c(left, middle), c(middle, right))
	for (r in 1:2) {
		i1 <- idx[r, 1]
		i2 <- idx[r, 2]
		b1 <- bnd[r, 1]
		b2 <- bnd[r, 2]
		if (depth < max.depth && any(have.zeros[i1:i2] == F)) {
			ds <- lambda.search(x, y, depth+1, max.depth,
					    have.zeros, b1, b2, i1, i2, XX,
					    Xy, gamma0, gammastep, gammastop,
					    IMsteps, force.zero, threshold)
			have.zeros <- have.zeros | ds$have.zeros
			lambdas <- c(lambdas, ds$lambdas)
			betas <- cbind(betas, ds$betas)
			iter <- iter + ds$iter
		}
	}

	out <- list(have.zeros=have.zeros, lambdas=lambdas, betas=betas,
		    iter=iter)
	return(out)
}
