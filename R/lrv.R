##'lrv: estimates the long run variance resp. covariance matrix of the supplied
##'     time series
##'
##'input: x (time series; numeric vector, matrix or ts object)
##'       b_n (bandwidth for kernel-based estimation; numeric; 
##'            default: length of time series ^ (1/3))
##'       l (block length for subsampling or bootstrap; numeric; 
##'          default: ??????)
##'       method (long run variance estimation method [for the univariate case];
##'               one of "kernel", "subsampling", "bootstrap")
##'       B (number of bootstrap samples; numeric)
##'       kFun (kernel function; character string)
##'       
##'output: long run variance (numeric value) or long run covariance matrix 
##'        (numeric matrix with dim. m x m, when m is the number of columns)

lrv <- function(x, method = c("kernel", "subsampling", "bootstrap", "none"), 
                control = list())
{
  method <- match.arg(method)
  if(method == "none") return(1)
  
  ## argument check
  if(is(x, "ts"))
  {
    class(x) <- "numeric"
  } 
  if(!(is(x, "matrix") || is(x, "numeric") || is(x, "integer")))
  {
    stop("x must be a numeric or integer vector or matrix!")
  }
  
  ### ***********
  con <- list(kFun = "bartlett", B = 1000, b_n = NA, l_n = NA, 
              gamma0 = TRUE, overlapping = TRUE, distr = FALSE, seed = NA, 
              version = "mean", alpha_Q = NA)
  nmsC <- names(con)
  con[(namc <- names(control))] <- control
  if(length(noNms <- namc[!namc %in% nmsC])) 
    warning("unknown names in control: ", paste(noNms, collapse = ", "))
  if(con$distr) con$version <- "distr"
  if(is.na(con$b_n) && !is.na(con$l_n) && method == "kernel") con$b_n <- con$l_n
  if(is.na(con$l_n) && !is.na(con$b_n) && (method == "subsampling" | method == "bootstrap"))
    con$l_n <- con$b_n
  ### ***********

  con$kFun <- pmatch(con$kFun, c("bartlett", "FT", "parzen", "QS", "TH", 
                                 "truncated", "SFT", "Epanechnikov", 
                                 "quadratic"))
  if(is.na(con$kFun))
  {
    warning("This kernel function does not exist. Tukey-Hanning kernel is used instead.")
    con$kFun <- 5
  }
  ## end argument check
  
  if(is(x, "matrix"))
  {
    if(method != "kernel") warning("Only kernel-based estimation of the long run variance is available for multivariate data.")
    m <- ncol(x)
    n <- nrow(x)
    b_n <- con$b_n
    
    if(!is.na(b_n) && (!is(b_n, "numeric") || b_n <= 0 || b_n > n))
    {
      stop("b_n must be numeric, greater than 0 and smaller than the length of the time series!")
    }

    if(is.na(b_n)) b_n <- log(n / 50, 1.8 + m / 40)
    if(b_n > n)
      stop("The bandwidth b_n cannot be larger than the length of the time series!")
    
    if(con$version != "mean")
    {
      if(con$version == "rho")
      {
        rks <- 1 - apply(x, 2, rank) / n
        erg <- .Call("lrv_rho", as.numeric(rks), as.numeric(n), as.numeric(m), 
                     as.numeric(b_n), as.numeric(con$kFun),
                     as.numeric(mean(apply(rks, 1, prod))^2))
      } else if(con$version == "tau")
      {
        f1 <- .Call("trafo_tau", as.numeric(x), as.numeric(n)) / n
        psi <- 4 * f1 - 2 * ecdf(x[, 1])(x[, 1]) - 2 * ecdf(x[, 2])(x[, 2]) + 
          1
        psi <- psi - mean(psi)
        erg <- 4 * .Call("lrv", as.numeric(psi), as.numeric(con$b_n), as.numeric(con$kFun), 
              PACKAGE = "robcp")
      } else
      {
        stop("version not supported!")
      }
    } else
    {
      x_cen <- apply(x, 2, function(x) x - mean(x))
    
      erg <- .Call("lrv_matrix", as.numeric(x_cen), as.numeric(n), as.numeric(m),
                   as.numeric(b_n), as.numeric(con$kFun),
                   PACKAGE = "robcp")
    
      erg <- matrix(erg, ncol = m)
    }
  } else
  {
    fact <- 1
    
    if(con$version == "distr")
    {
      x <- rank(x) / length(x)
    } else if(con$version == "empVar")
    {
      x <- (x - mean(x))^2 
    } else if(con$version == "MD")
    {
      x <- abs(x - median(x)) 
    } else if(con$version == "GMD")
    {
      fact <- 4
      x <- sapply(seq_along(x), function(i) mean(abs(x[-i] - x[i])))
    # } else if(con$version == "MAD")
    # {
    #   x_cen <- as.numeric(abs(x - median(x)) <= mad(x)) - 0.5
    } else if(con$version == "Qalpha")
    {
      n <- length(x)
      if(is.na(con$alpha_Q)) con$alpha_Q <- 0.5
      scale <- Qalpha(x, con$alpha_Q)[n - 1]
      
      fact <- 4 / .Call("Qalpha_u", as.numeric(x), as.numeric(n), as.numeric(scale),
                        as.numeric(IQR(x) * n^(-1/3)), as.numeric(8))^2
      #### as.numeric(8) = Epanechnikov kernel
      
      x <- sapply(x, function(xi) mean(as.numeric(abs(x - xi) <= scale)))
    } else if(con$version != "mean")
    {
      stop("version not supported!")
    }

    
    erg <- switch(method, 
           "kernel" = lrv_kernel(x, con$b_n, con$kFun, con$gamma0),
           "subsampling" = lrv_subs(x, con$l_n, con$overlapping, con$version == "distr"), 
           "bootstrap" = lrv_dwb(x, con$l_n, con$B, con$kFun, con$seed))
    
    # } else if(version == "MAD")
    # {
    #   erg <- erg / .Call("MAD_f", as.numeric(x), as.numeric(n), as.numeric(loc),
    #                      as.numeric(scale), as.numeric(IQR(abs(x - loc)) * n^(-1/3)-1), as.numeric(8))^2
    
    erg <- erg * fact
  }
  
  return(erg)
}


##'kernel estimation
##'
##'input: x (time series)
##'       b_n (bandwidth)
##'       kFun (kernel function)
##'       gamma0 (for the kernel-based estimation: if the estimated lrv is <= 0,
##'               should only the estimated value to the lag 0 be returned?; 
##'               default: TRUE)
##'               
##'@name lrv
lrv_kernel <- function(x, b_n, kFun, gamma0 = TRUE)
{
  n <- length(x)
  if(!is.na(b_n) && (!is(b_n, "numeric") || b_n <= 0 || b_n > n))
  {
    stop("b_n must be numeric, greater than 0 and smaller than the length of the time series!")
  }
  if(is.na(b_n)) 
  {
    b_n <- 0.9 * n^(1/3)
  }
  
  # if(distr)
  # {
  #   x <- rank(x) / n
  # }
  # 
  # if(version == "empVar")
  # {
  #   x <- (x - mean(x))^2 
  # } else if(version == "MD")
  # {
  #   x <- abs(x - median(x)) 
  # } else if(version == "GMD")
  # {
  #   x <- sapply(seq_along(x), function(i) mean(abs(x[-i] - x[i])))
  # } else if(version == "Qalpha")
  # {
  #   if(is.na(alpha_Q)) alpha_Q <- 0.5
  #   scale <- Qalpha(x, alpha_Q)[n-1]
  #   x_cen <- sapply(x, function(xi) mean(as.numeric(abs(x - xi) <= scale)))
  # }
  
  # if(version == "MAD")
  # {
  #   x_cen <- as.numeric(abs(x - median(x)) <= mad(x)) - 0.5
  # } else

  x_cen <- x - mean(x)
  
  erg <- .Call("lrv", as.numeric(x_cen), as.numeric(b_n), as.numeric(kFun),
               PACKAGE = "robcp")
  
  if(erg < 0 & gamma0)
  {
    warning("Estimated long run variance was < 0; only the estimated autocovariance to lag 0 is returned!")
    erg <- (n - 1) / n * var(x_cen)
  }
  
  # if(!is.na(version))
  # {
  #   if(version == "GMD")
  #   {
  #     erg <- erg * 4
  #   # } else if(version == "MAD")
  #   # {
  #   #   erg <- erg / .Call("MAD_f", as.numeric(x), as.numeric(n), as.numeric(loc),
  #   #                      as.numeric(scale), as.numeric(IQR(abs(x - loc)) * n^(-1/3)-1), as.numeric(8))^2
  #   } else if(version == "Qalpha")
  #   {
  #     erg <- erg * 4 / .Call("Qalpha_u", as.numeric(x), as.numeric(n), as.numeric(scale),
  #                            as.numeric(IQR(x) * n^(-1/3)), as.numeric(8))^2
  #     #### as.numeric(8) = Epanechnikov kernel
  #   }
  # }
  # 
  # if(distr)
  # {
  #   erg <- erg * sqrt(pi / 2)
  # }
  
  return(erg)
}


##'overlapping subsampling estimation
##'
##'input: x (time series)
##'       l (block length; numeric; 1 <= l <= length(x))
##'       overlapping (overlapping subsampling? boolean)
##'       distr (distribution function or plain observations? boolean)
##'       
##'@name lrv
lrv_subs <- function(x, l, overlapping = TRUE, distr = FALSE)
{
  ## argument check
  if(!is.na(l) && (!is(l, "numeric") || l <= 0))
  {
    stop("l must be numeric and greater than 0!")
  }
  
  n <- length(x)
  if(missing(l) | is.na(l)) 
  {
    rho <- abs(cor(x[1:(n-1)], x[2:n], method = "spearman"))
    if(rho == 1) stop("Correlation estimated to be 1. Please specify l manually.")
    l <- min(max(ceiling(n^(1/3) * ((2 * rho) / (1 - rho^2))^(2/3)), 1), n)
    l <- tryCatch(as.integer(l), error = function(e) stop("Integer overflow in default l estimation. Please specify a value manually."), 
                  warning = function(w) stop("Integer overflow in default l estimation. Please specify a value manually."))
  }
  
  if(!overlapping)
  {
    if(distr)
    {
      # x <- rank(x) / n
      meanX <- (n + 1) / (2 * n) * l
    } else
    {
      meanX <- mean(x) * l
    }
    res <- .Call("lrv_subs_nonoverlap", as.numeric(x), as.numeric(l),
               as.numeric(meanX), as.numeric(distr))
  } else
  {
    res <- .Call("lrv_subs_overlap", as.numeric(x), as.numeric(l), as.numeric(distr))
  }
  
  if(distr) res <- res^2
  return(res)
}


##'dependent wild bootstrap estimation 
##'
##'input: x (time series)
##'       l (block length??, 1 <= l)
##'       B (number of bootstrap samples, numeric > 0)
##'       seed (start for random number generator)
##'       
##'@name lrv
lrv_dwb <- function(x, l, B, kFun, seed = NA)
{
  n <- length(x)
  
  ## argument check
  if(!is.na(l) && (!is.numeric(l) || l < 1 || l > n))
  {
    stop("l must be a positive integer and cannot be larger than the length of x!")
  }
  if(missing(l) | is.na(l)) 
  {
    rho <- abs(cor(x[1:(n-1)], x[2:n], method = "spearman"))
    l <- max(ceiling(n^(1/3) * ((2 * rho) / (1 - rho^2))^(2/3)), 1)
    l <- tryCatch(as.integer(l), error = function(e) stop("Integer overflow in default l estimation. Please specify a value manually."), 
                  warning = function(w) stop("Integer overflow in default l estimation. Please specify a value manually."))
  }
  if(!is.na(B) && (!is.numeric(B) || B < 1)) 
  {
    stop("B has to be a positive integer!")
  }
  if(is.na(B)) B <- 1000
  if(!(kFun %in% c(1, 3, 4))) 
  {
    warning("Specified kernel function is not supported for the dependet wild bootstrap.
             Bartlett kernel is used.")
  }
  
  # if(distr)
  # {
  #   x <- rank(x) / n
  # }
  
  sigma.ma <- matrix(.Call("gen_matrix", as.numeric(n), as.numeric(l),
                           as.numeric(kFun)), ncol = n)
  
  ## dependency matrix
  sigma.root <- pracma::sqrtm(sigma.ma)$B
  ## set seed
  if(!is.na(seed)) set.seed(seed)
  ## bootstrap samples
  dwb <- replicate(B, 
  {
    z <- rnorm(n)
    eps <- sigma.root %*% z
    x_star <- mean(x) + (x - mean(x)) * eps
    mean(x_star)
  })
  
  return(var((dwb - mean(x)) * sqrt(n)))
}

