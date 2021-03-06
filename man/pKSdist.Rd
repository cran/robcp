\encoding{utf8}
\name{pKSdist}
\alias{pKSdist}
\alias{pbessel3}

\title{
Asymptotic cumulative distribution for the Huberized CUSUM Test statistic
}
\description{
Computes the asymptotic cumulative distribution of the statistic of \code{teststat}.
}
\usage{
pKSdist(tn, tol = 1e-8)
pbessel3(tn, h)
}

\arguments{
  \item{tn}{vector of test statistics (numeric). For \code{pbessel3} length of \code{tn} has to be 1.}
  \item{h}{dimension of time series (integer). If \code{h} is equal to 1 \code{pbessel3} uses \code{pKS2} to compute the corresponding probability.}
  \item{tol}{tolerance (numeric).}
}

\details{
For a single time series, the distribution is the same distribution as in the two sample Kolmogorov Smirnov Test, namely the distribution of the maximal value of the absolute values of a Brownian bridge. It is computated as follows (van Mulbregt, 2018):

For \eqn{t_n(x) < 1}:

\deqn{
P(t_n(X) \le t_n(x)) = 
\sqrt{2 * \pi} / t_n(x) * t (1 + t^8(1 + t^{16}(1 + t^{24}(1 + ...))))}
up to \eqn{t^{8 * k_{max}},
k_{max} = \lfloor \sqrt{2 - \log(tol)}\rfloor} where \eqn{t = \exp(-\pi^2 / (8*x^2))}

else:

\deqn{
P(t_n(X) \le t_n(x)) = 2 * \sum_{k = 1}^{\infty} (-1)^{k - 1} * \exp(-2*k^2*x^2)}
until
\eqn{|2 * (-1)^{k - 1} * \exp(-2*k^2*x^2) - 2 * (-1)^{(k-1) - 1} * \exp(-2*(k-1)^2*x^2)| \le tol.
}

In case of multiple time series, the distribution equals that of the maximum of an \code{h} dimensional squared Bessel bridge. It can be computed by (Kiefer, 1959):

\deqn{P(t_n(X) \le t_n(x)) = 
(4 / (\Gamma(h / 2) 2^{h / 2} t_n^h)) \sum_{i = 1}^{\infty} ( ((\gamma_{(h - 2)/2, n})^{h - 2} \exp(-(\gamma_{(h - 2)/2, n})^2 / (2t_n^2))) / (J_{h/2}(\gamma_{(h - 2)/2, n}))^2 )}
where \eqn{J_h} is the Bessel function of first kind and h-th order, \eqn{\Gamma} is the gamma function and \eqn{\gamma_{h, n}} denotes the n-th zero of \eqn{J_h}.
}

\value{
vector of \eqn{P(t_n(X) \le tn[i])}.
}

\references{
van Mulbregt, P. (2018) "Computing the Cumulative Distribution Function and Quantiles of the limit of the Two-sided Kolmogorov-Smirnov Statistic." arXiv preprint arXiv:1803.00426.

/src/library/stats/src/ks.c rev60573

Kiefer, J. (1959). "K-sample analogues of the Kolmogorov-Smirnov and Cramer-V. Mises tests", \emph{The Annals of Mathematical Statistics}, 420--447.
}

\author{
Sheila Görz, Alexander Dürre
}

\seealso{
\code{\link{psi}}, \code{\link{teststat}}, \code{\link{h_cumsum}}, \code{\link{huber_cusum}}
}

\examples{
# single time series
timeSeries <- c(rnorm(20, 0), rnorm(20, 2))
tn <- teststat(timeSeries)

pKSdist(tn)

# two time series
timeSeries <- matrix(c(rnorm(20, 0), rnorm(20, 2), rnorm(20, 1), rnorm(20, 3), 
                     ncol = 2))
tn <- teststat(timeSeries)

pbessel3(tn, 2)

}

