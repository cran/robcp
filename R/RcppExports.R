# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#' Computes the Q-alpha statistic.
#' @param x Numeric vector.
#' @param alpha quantile. Numeric value in (0, 1]
#'
#' @return numeric vector of Qalpha-s estimated using x[1], ..., x[k], k = 1, ..., n, n being the length of x.
#'
#' @examples 
#' x <- rnorm(10)
#' Qalpha(x, 0.5)
Qalpha <- function(x, alpha = 0.8) {
    .Call('_robcp_Qalpha', PACKAGE = 'robcp', x, alpha)
}

#' Computes the weighted median of a numeric vector.
#' @param x Numeric vector.
#' @param w Integer vector of weights
#'
#' @return Weighted median of x with respect to w.
#'
#' @examples 
#' x <- c(1, 4, 9)
#' w <- c(5, 1, 1)
#' weightedMedian(x, w)
weightedMedian <- function(x, w) {
    .Call('_robcp_weightedMedian', PACKAGE = 'robcp', x, w)
}

#'kthPair:
#'
#'input: - X and Y (numeric vectors; descending order)
#'       - n and m (lengths of x and y; integer)
#'       - k (index of element to choose; integer; 1 <= k <= n * m)
#'
kthPair <- function(X, Y, k, k2 = NA_integer_) {
    .Call('_robcp_kthPair', PACKAGE = 'robcp', X, Y, k, k2)
}

