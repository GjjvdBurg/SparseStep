#' @title Coordinate descent algorithm for SparseStep
#'
#'
#' @export
#'
sparsestep.cd <- function(x, y, lambdas=NULL, epsilon=1e-5, intercept=TRUE,
			  ...)
{
	nm <- dim(X)
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

	XX <- t(x) %*% x
	Xy <- t(x) %*% y

	#gammas <- 2^(seq(log(1e6)/log(2), log(1e-8)/log(2)))

	num.lambdas <- length(lambdas)
	#num.gammas <- length(gammas)
	
	#betas <- array(0, dim=c(num.gammas, num.lambdas, m))
	betas <- array(0, dim=c(num.lambdas, m))
	for (l in num.lambdas:1) {
		lambda <- lambdas[l]
		# initialize beta
		if (l == num.lambdas) {
			beta <- as.vector(matrix(0, 1, m))
		} else {
			#beta <- betas[num.gammas, l+1, ]
			beta <- betas[l+1, ]
		}

		j <- 1
		last.beta <- as.vector(matrix(0, 1, m))
		while (TRUE) {
			# code
			b <- -2 * x[, j] %*% (y - x[, -j] %*% last.beta[-j])
			a <- x[, j] %*% x[, j]
			if (abs(last.beta[j]) > epsilon) {
				beta[j] <- b/a
			} else {
				beta[j] <- (2*b - lambda*sign(last.beta[j]))/
					(2*a)
			}
			# check convergence
			if (sum(abs(beta - last.beta)) < 1e-10) {
				break
			} else {
				last.beta <- beta
			}
			# continue
			j <- j %% m + 1
		}
		betas[l, ] <- beta
	}

	return(betas)
}



