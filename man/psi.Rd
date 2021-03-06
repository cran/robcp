\encoding{utf8}
\name{psi}
\alias{psi}

\title{
Transformation of time series
}
\description{
Computation of values tranformed by their median, MAD and a \eqn{\psi} function.
}

\usage{
psi(y, fun = "HLm", k, constant = 1.4826)
}

\arguments{
	\item{y}{vector or matrix with each column representing a time series (numeric).}
	\item{fun}{character string specifiyng the transformation function \eqn{\psi}.}
	\item{k}{numeric bound used for Huber type psi-functions which determines robustness and efficiency of the test. Default for \code{psi = "HLg"} or \code{"HCg"} is \code{sqrt(qchisq(0.8, df = m)} where \code{m} are the number of time series, and otherwise it is 1.5.}
	\item{constant}{scale factor of the MAD.}
}

\value{
Transformed numeric vector or matrix with the same number of rows as \code{y}.
}

\details{
Let \eqn{x = (y - Median(y)) / MAD(y)} be the standardized values of a single time series.

Available \eqn{\psi} functions are: \cr

marginal Huber for location: \cr
\code{fun = "HLm"}. \cr
\eqn{\psi_{HLm}(x) = k * 1_{x > k} + z * 1_{-k \le x \le k} - k * 1_{x < -k}}. \cr

global Huber for location: \cr
\code{fun = "HLg"}. \cr
\eqn{\psi_{HLg}(x) = x * 1_{0 < |x| \le k} + k* x/|x| * 1_{|x| > k}}. \cr

marginal sign for location: \cr
\code{fun = "VLm"}. \cr
\eqn{\psi_{VLm}(x_i) = sign(x_i)}. \cr

global sign for location: \cr
\code{fun = "VLg"}. \cr
\eqn{\psi_{VLg}(x) = x / |x| * 1_{|x| > 0}}. \cr

marginal Huber for covariance: \cr
\code{fun = "HCm"}. \cr
\eqn{\psi_{HCm}(x) = \psi_{HLm}(x) \psi_{HLm}(x)^T}. \cr

global Huber for covariance: \cr
\code{fun = "HCg"}. \cr
\eqn{\psi_{HCg}(x) = \psi_{HLg}(x) \psi_{HLg}(x)^T}. \cr

marginal sign covariance: \cr
\code{fun = "VCm"}. \cr
\eqn{\psi_{VCm}(x) = \psi_{VLm}(x) \psi_{VLm}(x)^T}. \cr

gloabl sign covariance: \cr
\code{fun = "VCg"}. \cr
\eqn{\psi_{VCg}(x) = \psi_{VCg}(x) \psi_{VCg}(x)^T}. \cr

Note that for all covariances only the upper diagonal is used and turned into a vector. In case of the marginal sign covariance, the main diagonal is also left out. At the global sign covariance matrix the last element of the main diagonal is left out.
}

\seealso{
\code{\link{h_cumsum}}, 
\code{\link{teststat}}
}


\author{
Sheila Görz
}


\examples{
psi(rnorm(100))
}
