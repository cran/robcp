context("kth Pair")

test_that("Output of kthPair and medianDiff is of the correct format", 
{
  expect_error(kthPair(1:3, 1:3, 0))
  expect_error(kthPair(1:3, 1:3, 10))
  
  ## medianDiff
})

test_that("kthPair returns the correct value",
{
  x <- rnorm(10)
  y <- runif(10)
  
  res1 <- sapply(1:100, function(k) kthPair(x, y, k))
  res2 <- sort(apply(expand.grid(x, y), 1, sum), decreasing = TRUE)
  
  expect_equal(res1, res2)
})

test_that("medianDiff returns the correct value",
{
  x <- sample(1:100, replace = TRUE)
  
  expect_equal(medianDiff(x, 1), median(x - 1))
  expect_equal(medianDiff(1, x), median(1 - x))
  
  y <- rnorm(100)
  
  expect_equal(medianDiff(x, y), median(apply(expand.grid(x, -y), 1, sum)))
  
  x <- runif(99)
  
  expect_equal(medianDiff(x, 1), median(x - 1))
  expect_equal(medianDiff(1, x), median(1 - x))
  
  y <- rnorm(99)
  
  expect_equal(medianDiff(x, y), median(apply(expand.grid(x, -y), 1, sum)))
})