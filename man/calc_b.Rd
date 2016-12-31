% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_b.R
\encoding{UTF-8}
\name{calc_b}
\alias{calc_b}
\title{Calculate the metabolic scaling coefficient, b}
\usage{
calc_b(mass, MO2, plot = "linear")
}
\arguments{
\item{mass}{a vector of animal masses.}

\item{MO2}{a vector of metabolic rates.}

\item{plot}{a string defining what kind of plot to display. "linear" for linear axes, "log" for log10-scale axes, and "none" for no plot. Default is "linear".}
}
\description{
For most organisms, metabolic rate does not scale linearly, but rather according to a power function: \eqn{MO2 = b0 * M^b}. This function estimates the scaling coefficient, \code{b}, given MO2s from different sized individuals.
}
\details{
\deqn{MO2 = b0 * M^b}
where \code{b0} is species-specific normalization constant, \code{M} is mass and \code{b} is the scaling coefficient.
}
\examples{
# Simple example
mass <- c(1, 10, 100, 1000, 40, 4, 400, 60, 2, 742, 266, 983) # made up values
MO2 <- mass ^ 0.65 + rnorm(n = length(mass)) # make up some data
calc_b(mass = mass, MO2 = MO2)

# How about some mass-specific MO2s?
msMO2 <- mass ^ -0.25 + rnorm(n = length(mass), sd = 0.05)
calc_b(mass = mass, MO2 = msMO2)
calc_b(mass = mass, MO2 = msMO2, plot = "log")

}
\author{
Matthew A. Birk, \email{matthewabirk@gmail.com}
}
\seealso{
\code{\link{scale_MO2}}, \code{\link{calc_MO2}}
}
