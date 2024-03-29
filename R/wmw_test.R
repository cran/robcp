## wmw_test

##'@name wmw_test
##'@title Wilocxon-Mann-Whitney Test for Change Points 
##'@description Performs the Wilcoxon-Mann-Whitney change point test.
##'@param x time series (numeric or ts vector).
##'@param h version of the test (integer, 1 or 2)
##'@param method method for estimating the long run variance.
##'@param control a list of control parameters.
##'@param tol tolerance of the distribution function (numeric), which is used do compute p-values.
##'@return A list fo the class "htest" containing
wmw_test <- function(x, h = 1L, method = "kernel", control = list(), 
                     tol = 1e-8, plot = FALSE)
{
  Dataname <- deparse(substitute(x))
  stat <- wilcox_stat(x, h = h, method = method, control = control)
  if(!is.finite(stat)) stat <- 0
  location <- attr(stat, "cp-location")
  names(stat) <- "S"
  
  erg <- list(alternative = "two-sided", method = "Wilcoxon-Mann-Whitney change point test",
              data.name = Dataname, statistic = stat,
              p.value = 1 - pKSdist(stat, tol), 
              cp.location = location, 
              lrv = list(method = attr(stat, "lrv-method"), 
                         param = attr(stat, "param"), 
                         value = attr(stat, "sigma")))
  
  if(plot) plot(stat)
  
  class(erg) <- "htest"
  return(erg)
}