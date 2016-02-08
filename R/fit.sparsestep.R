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
#' @param use.XX whether or not to compute X'X and return it
#' @param use.Xy whether or not to compute X'y and return it
#'
#' @return A "sparsestep" object is returned, for which predict, coef, methods 
#' exist.
#'
#' @export
#'
#' @examples
#' data(diabetes)
#' attach(diabetes)
#' object <- sparsestep(x, y)
#' plot(object)
#' detach(diabetes)
#'
sparsestep <- function(x, y, lambda=1.0, gamma0=1e6, 
		       gammastop=1e-8, IMsteps=2, gammastep=2.0, normalize=TRUE,
		       intercept=TRUE, force.zero=TRUE, threshold=1e-7,
		       XX=NULL, Xy=NULL, use.XX = TRUE, use.Xy = TRUE)
{
	call <- match.call()

	nm <- dim(x)
	n <- nm[1]
	m <- nm[2]
	one <- rep(1, n)

	if (intercept) {
		meanx <- drop(one %*% x)/n
		x <- scale(x, meanx, FALSE)
		mu <- mean(y)
		y <- drop(y - mu)
	} else {
		meanx <- rep(0, m)
		mu <- 0
		y <- drop(y)
	}

	if (normalize) {
		normx <- sqrt(drop(one %*% (x^2)))
		names(normx) <- NULL
		x <- scale(x, FALSE, normx)
		cat("Normalizing in sparsestep\n")
	} else {
		normx <- rep(1, m)
	}

	if (use.XX & is.null(XX)) {
		XX <- t(x) %*% x
	}
	if (use.Xy & is.null(Xy)) {
		Xy <- t(x) %*% y
	}

	# Start solving SparseStep	
	gamma <- gamma0
	beta <- matrix(0.0, m, 1)

	it <- 0
	while (gamma > gammastop)
       	{
		for (i in 1:IMsteps) {
			alpha <- beta
			omega <- gamma/(alpha^2 + gamma)^2
			Omega <- diag(as.vector(omega), m, m)
			beta <- solve(XX + lambda * Omega, Xy)
		}
		it <- it + 1
		gamma <- gamma / gammastep
	}

	# perform IM until convergence
	epsilon <- 1e-14
	loss <- get.loss(x, y, gamma, beta, lambda)
	lbar <- (1.0 + 2.0 * epsilon) * loss
	while ((lbar - loss)/loss > epsilon)
	{
		alpha <- beta
		omega <- gamma/(alpha^2 + gamma)^2
		Omega <- diag(as.vector(omega), m, m)
		beta <- solve(XX + lambda * Omega, Xy)
		lbar <- loss
		loss <- get.loss(x, y, gamma, beta, lambda)
	}

	# postprocessing
	if (force.zero) {
		beta[which(abs(beta) < threshold)] <- 0
	}
	residuals <- y - x %*% beta
	beta <- scale(t(beta), FALSE, normx)
	RSS <- apply(residuals^2, 2, sum)
	R2 <- 1 - RSS/RSS[1]

	object <- list(call = call, lambda = lambda, R2 = R2, RSS = RSS,
		       gamma0 = gamma0, gammastop = gammastop,
		       IMsteps = IMsteps, gammastep = gammastep,
		       intercept = intercept, force.zero = force.zero,
		       threshold = threshold, beta = beta, mu = mu,
		       normx = normx, meanx = meanx,
		       XX = if(use.XX) XX else NULL,
		       Xy = if(use.Xy) Xy else NULL)
	class(object) <- "sparsestep"
	return(object)
}

get.loss <- function(x, y, gamma, beta, lambda)
{
	Xb <- x %*% beta
	diff <- y - Xb
	b2 <- beta^2
	binv <- 1/(b2 + gamma)
	loss <- t(diff) %*% diff + lambda * t(b2) %*% binv
	return(loss)
}
