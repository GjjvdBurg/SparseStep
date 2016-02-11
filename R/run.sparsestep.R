# Core SparseStep routine. This could be implemented in a low-level language 
# in the future, if necessary.
#
run.sparsestep <- function(x, y, XX, Xy, nvars, lambda, gamma0, gammastep,
			   gammastop, IMsteps, force.zero, threshold) {
	# Start solving SparseStep
	gamma <- gamma0
	beta <- matrix(0.0, nvars, 1)

	it <- 0
	while (gamma > gammastop)
	{
		for (i in 1:IMsteps) {
			alpha <- beta
			omega <- gamma^2/(alpha^2 + gamma^2)^2
			Omega <- diag(as.vector(omega), nvars, nvars)
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
		omega <- gamma^2/(alpha^2 + gamma^2)^2
		Omega <- diag(as.vector(omega), nvars, nvars)
		beta <- solve(XX + lambda * Omega, Xy)
		lbar <- loss
		loss <- get.loss(x, y, gamma, beta, lambda)
	}

	# postprocessing
	if (force.zero) {
		beta[which(abs(beta) < threshold)] <- 0
	}
	return(beta)
}

get.loss <- function(x, y, gamma, beta, lambda)
{
	Xb <- x %*% beta
	diff <- y - Xb
	b2 <- beta^2
	binv <- 1/(b2 + gamma^2)
	loss <- t(diff) %*% diff + lambda * t(b2) %*% binv
	return(loss)
}
