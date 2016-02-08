#' @title Path algorithm for the SparseStep model
#'
#' @description Fits the entire regularization path for SparseStep using a 
#' Golden Section search.
#'
#' @param x matrix of predictors
#' @param y response
#' @param max.depth maximum recursion depth
#' @param ... further arguments to sparsestep()
#'
#' @export
#'
sparsestep.path <- function(x, y, max.depth=10, intercept=TRUE,
			    normalize=TRUE, ...)
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
		cat("Normalizing in path.sparsestep\n")
	} else {
		normx <- rep(1, m)
	}

	XX <- t(x) %*% x
	Xy <- t(x) %*% y

	iter <- 0

	# First find the smallest lambda for which all coefficients are zero
	lambda.max <- 2^25
	fit <- NULL
	while (1) {
		last.fit <- fit
		fit <- sparsestep(x, y, lambda=lambda.max, normalize=FALSE, 
				  XX=XX, Xy=Xy, ...)
		iter <- iter + 1
		if (all(fit$beta == 0)) {
			lambda.max <- lambda.max / 2
		} else {
			lambda.max <- lambda.max * 2
			break
		}
	}
	cat("Found maximum value of lambda: 2^(", log(lambda.max)/log(2), ")\n")
	iter <- iter + 1
	if (is.null(last.fit)) {
		betas.max <- fit$beta
	} else {
		betas.max <- last.fit$beta
	}

	# Now find the largest lambda for which no coefficients are zero
	lambda.min <- 2^-12
	fit <- NULL
	while (1) {
		last.fit <- fit
		fit <- sparsestep(x, y, lambda=lambda.min, normalize=FALSE, 
				  XX=XX, Xy=Xy, ...)
		iter <- iter + 1
		if (all(fit$beta != 0)) {
			lambda.min <- lambda.min * 2
		} else {
			lambda.min <- lambda.min / 2
			break
		}
	}
	cat("Found minimum value of lambda: 2^(", log(lambda.min)/log(2), ")\n")
	iter <- iter + 1
	if (is.null(last.fit)) {
		betas.min <- fit$beta
	} else {
		betas.min <- last.fit$beta
	}

	# Run binary section search
	have.zeros <- as.vector(matrix(FALSE, 1, m+1))
	have.zeros[1] <- TRUE
	have.zeros[m+1] <- TRUE

	left <- log(lambda.min)/log(2)
	right <- log(lambda.max)/log(2)

	l <- lambda.search(x, y, 0, max.depth, have.zeros, left, right, 1, 
			   m+1, XX, Xy, ...)
	have.zeros <- have.zeros | l$have.zeros
	lambdas <- c(lambda.min, l$lambdas, lambda.max)
	betas <- rbind(betas.min, l$betas, betas.max)
	iter <- iter + l$iter

	ord <- order(lambdas)
	lambdas <- lambdas[ord]
	betas <- betas[ord, ]
	betas <- scale(betas, FALSE, normx)

	object <- list(call=call, lambdas=lambdas, betas=betas,
		       iterations=iter)
}

lambda.search <- function(x, y, depth, max.depth, have.zeros, left, right,
			  lidx, ridx, XX, Xy, ...)
{
	cat("Running search in interval [", left, ",", right, "] ... \n")
	nm <- dim(x)
	m <- nm[2]

	betas <- NULL
	lambdas <- NULL

	middle <- left + (right - left)/2
	lambda <- 2^middle
	fit <- sparsestep(x, y, lambda=lambda, normalize=FALSE, XX=XX, Xy=Xy, 
			  ...)
	iter <- 1

	num.zero <- length(which(fit$beta == 0))
	cidx <- num.zero + 1
	if (have.zeros[cidx] == FALSE) {
		have.zeros[cidx] = TRUE
		betas <- rbind(betas, as.vector(fit$beta))
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
					    have.zeros, b1, b2, i1, i2, XX, Xy,
					    ...)
			have.zeros <- have.zeros | ds$have.zeros
			lambdas <- c(lambdas, ds$lambdas)
			betas <- rbind(betas, ds$betas)
			iter <- iter + ds$iter
		}
	}

	out <- list(have.zeros=have.zeros, lambdas=lambdas, betas=betas,
		    iter=iter)
	return(out)
}
