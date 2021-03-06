% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict.sparsestep.R
\name{predict.sparsestep}
\alias{predict.sparsestep}
\alias{predict}
\title{Make predictions from a SparseStep model}
\usage{
\method{predict}{sparsestep}(object, newx, ...)
}
\arguments{
\item{object}{Fitted \code{sparsestep} object}

\item{newx}{Matrix of new values for \code{x} at which predictions are to 
be made.}

\item{\dots}{further argument are ignored}
}
\value{
a matrix of numerical predictions of size nobs x nlambda
}
\description{
Predicts the outcome variable for the SparseStep model for 
each value of lambda supplied to the model.
}
\examples{
x <- matrix(rnorm(100*20), 100, 20)
y <- rnorm(100)
fit <- sparsestep(x, y)
yhat <- predict(fit, x)

}
\references{
Van den Burg, G.J.J., Groenen, P.J.F. and Alfons, A. (2017).
 \emph{SparseStep: Approximating the Counting Norm for Sparse Regularization},
 arXiv preprint arXiv:1701.06967 [stat.ME]. 
 URL \url{https://arxiv.org/abs/1701.06967}.
}
\author{
Gerrit J.J. van den Burg, Patrick J.F. Groenen, Andreas Alfons\cr
Maintainer: Gerrit J.J. van den Burg <gertjanvandenburg@gmail.com>
}
