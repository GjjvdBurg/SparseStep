postprocess <- function(betas, a0, x, normx, nvars, nlambdas) {
	betas <- scale(betas, FALSE, normx)

	# add names
	vnames <- colnames(x)
	if (is.null(vnames)) { vnames <- paste("V", seq(nvars), sep="") }
	stepnames <- paste("s", seq(nlambdas)-1, sep="")
	colnames(betas) <- vnames
	rownames(betas) <- stepnames

	a0 <- t(as.matrix(rep(a0, nlambdas)))
	colnames(a0) <- stepnames
	rownames(a0) <- "Intercept"

	# Make it a sparse matrix
	beta <- drop0(Matrix(as.matrix(t(betas))))

	out <- list(beta = beta, a0 = a0)

	return(out)
}
