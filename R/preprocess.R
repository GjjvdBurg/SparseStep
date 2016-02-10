preprocess <- function(x, y, normalize, intercept, XX, Xy, use.XX, use.Xy)
{
	nm <- dim(x)
	nobs <- nm[1]
	nvars <- nm[2]
	one <- rep(1, nobs)

	if (intercept) {
		meanx <- drop(one %*% x)/nobs
		x <- scale(x, meanx, FALSE)
		a0 <- mean(y)
		y <- drop(y - a0)
	} else {
		meanx <- rep(0, nvars)
		a0 <- 0
		y <- drop(y)
	}

	if (normalize) {
		normx <- sqrt(drop(one %*% (x^2)))
		names(normx) <- NULL
		x <- scale(x, FALSE, normx)
		cat("Normalizing in sparsestep\n")
	} else {
		normx <- rep(1, nvars)
	}

	if (use.XX & is.null(XX)) {
		XX <- t(x) %*% x
	}
	if (use.Xy & is.null(Xy)) {
		Xy <- t(x) %*% y
	}

	out <- list(nvars = nvars, normx = normx, a0 = a0,
		    XX = XX, Xy = Xy, meanx = meanx)
	return(out)
}
