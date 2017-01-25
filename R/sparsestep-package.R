#' SparseStep: Approximating the Counting Norm for Sparse Regularization
#'
#' In the SparseStep regression model the ordinary least-squares problem is 
#' augmented with an approximation of the exact \eqn{\ell_0}{l[0]} pseudonorm.  
#' This approximation is made increasingly more accurate in the SparseStep 
#' algorithm, resulting in a sparse solution to the regression problem. See 
#' the references for more information.
#'
#' @section SparseStep functions:
#' The main SparseStep functions are:
#' \describe{
#' \item{\code{\link{sparsestep}}}{Fit a SparseStep model for a given range of 
#' \eqn{\lambda} values}
#' \item{\code{\link{path.sparsestep}}}{Fit the SparseStep model along a path 
#' of \eqn{\lambda} values which are generated such that a model is created at 
#' each possible level of sparsity, or until a given recursion depth is 
#' reached.}
#' }
#'
#' Other available functions are:
#' \describe{
#' \item{\code{\link{plot}}}{Plot the coefficient path of the SparseStep 
#' model.}
#' \item{\code{\link{predict}}}{Predict the outcome of the linear model using 
#' SparseStep}
#' \item{\code{\link{coef}}}{Get the coefficients from the SparseStep model}
#' \item{\code{\link{print}}}{Print a short description of the SparseStep 
#' model}
#' }
#'
#' @author
#' Gerrit J.J. van den Burg, Patrick J.F. Groenen, Andreas Alfons\cr
#' Maintainer: Gerrit J.J. van den Burg <gertjanvandenburg@gmail.com>
#'
#' @references
#' Van den Burg, G.J.J., Groenen, P.J.F. and Alfons, A. (2017).
#'  \emph{SparseStep: Approximating the Counting Norm for Sparse Regularization},
#'  arXiv preprint arXiv:1701.06967 [stat.ME]. 
#'  URL \url{https://arxiv.org/abs/1701.06967}.
#'
#' @name sparsestep-package
#' @docType package
#' @import Matrix
NULL
#>NULL
