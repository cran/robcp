## Wilcoxon-Mann-Whitney 

##'@name wilcox_stat
##'@title Wilcoxon-Mann-Whitney Test Statistic for Change Points
##'@description Computes the test statistic for the Wilcoxon-Mann-Whitney change point test
##'@param x time series (numeric or ts vector)
##'@param h version of the test (integer, 1 or 2)
##'@param method method for estimating the long run variance
##'@param control a list of control parameters for the estimation of the long run variance
##'@return Test statistic (numeric value) with the attribute cp-location 
##'        indicating at which index a change point is most likely. Is an S3
##'        object of the class cpStat

wilcox_stat <- function(x, h = 1L, method = "subsampling", control = list())
{
  ## argument check
  if(is(x, "ts"))
  {
    class(x) <- "numeric"
    tsp <- attr(x, "tsp")
  }
  if(!(is(x, "matrix") || is(x, "numeric") || is(x, "integer")))
  {
    stop("x must be a numeric or integer vector or matrix!")
  }
  if(is.null(control$overlapping)) 
  {
    control$overlapping <- FALSE
  }
  
  n <- length(x)
  
  if(is.numeric(h))
  {
    if(!(h %in% 1:2)) 
    {
      stop("Wrong test version h!")
      #stop("h must be either 1 or 2!")
    }
    if(is.null(control$distr))
    {
      control$distr <- h == 1L
    } else
    {
      if(is.logical(control$distr) & 2 - as.numeric(control$distr) != h)
      {
        warning("Argument for 'distr' not suitable for test version.")
      }
    }
    if(h == 2L)
    {
      res <- .Call("CUSUM", as.numeric(x))
    } else
    {
      res <- .Call("wilcox", as.numeric(x), as.numeric(h))
    }
  } else if(is.function(h))
  {
    hVec <- Vectorize(h)
    res <- sum(hVec(x[1], x[-1]))
    max <- abs(res)
    loc <- 1
    
    sapply(2:(n-1), function(k)
    {
      res <<- res - sum(hVec(x[1:(k-1)], x[k])) + sum(hVec(x[k], x[(k+1):n]))
      
      if(abs(res) > max)
      {
        max <<- abs(res)
        loc <<- k
      }
    })
    res[1] <- max
    res[2] <- loc
  } else
  {
    stop("Invalid argument for h!")
  }
  
  k <- res[2]
  x.adj <- x
  x.adj[(k+1):n] <- x.adj[(k+1):n] - mean(x[(k+1):n]) + mean(x[1:k])
  
  if(method == "subsampling" & (is.null(control$l) || is.na(control$l)))
  {
    rho <- cor(x.adj[-n], x.adj[-1], method = "spearman")
    control$l <- max(ceiling(n^(1/3) * ((2 * rho) / (1 - rho^2))^(2/3)), 1)
  }
  
  if(method == "kernel" & (is.null(control$b_n) || is.na(control$b_n)))
  {
    rho <- cor(x.adj[-n], x.adj[-1], method = "spearman")
    control$b_n <- max(ceiling(n^(1/3) * ((2 * rho) / (1 - rho^2))^(2/3)), 1)
  }
  
  Tn <- res[1] / sqrt(lrv(x, method = method, control = control))
    
  attr(Tn, "cp-location") <- k
  class(Tn) <- "cpStat"
  
  return(Tn)
}




