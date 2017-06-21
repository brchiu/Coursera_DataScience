## This program provides an implementation of cached matrix inverse.
##

# Function : makeCacheMatrix
# This function creates a special "matrix" object that can cache its inverse.
#
# Input :
# x : an (invertible)-matrix object
#
# Output :
# A list of interfaces applied to this special "matrix" object which consists
# of setmatrix, getmatrix, getinverse

makeCacheMatrix <- function(x = matrix()) {
  # inv_m is an internal state variable of closure makeCacheMatrix
  inv_x <- NULL
  
  setmatrix <- function(y) {
    # perform some error checking
    if (class(y) != "matrix") {
      message("Input parameter should be a matrix object.")
      return
    }
    if (dim(y)[1] != dim(y)[2]) {
      message("Input matrix x should be a square matrix.")
      return
    }
    if (det(y) == 0) {
      message("input matrix x should be invertible")
      return
    }
    
    if (is.null(x) || (!is.null(x) && !identical(y, x))) {
      x <<- y
      inv_x <- NULL
    }
  }
  getmatrix <- function()
    x
  
  # IMHO, there should not be setinverse function, since the inverse of a matrix
  # is its intrinsic property. It is determined at setmatrix, though evaluation
  # of it can be deferred when getinverse called.
  setinverse <- function(inv) {
    inv_x <<- inv
  }
  getinverse <- function() {
    if (is.null(x)) {
      message("Cached matrix has not be set !")
      return
    }
    inv_x
  }
  
  list(
    setmatrix = setmatrix, getmatrix = getmatrix, setinverse = setinverse, getinverse = getinverse
  )
}


# Function : cacheSolve
# If the inverse matrix of input object has not been calculated (or set) yet,
# this function calculates its inverse and stores to object's internal state
# variable, then return it to caller.
# If the inverse matrix exists in input objet, then return it directly.
#
# Input :
# x : an (invertible)-matrix object
#
# Output :
# Inverse matrix of input special "matrix" object.

cacheSolve <- function(x, ...) {
  ## Return a matrix that is the inverse of 'x'
  
  inv_x <- x$getinverse()
  if (!is.null(inv_x)) {
    message("getting cached data")
    return (inv_x)
  }
  data <- x$getmatrix()
  inv_x <- solve(data)
  x$setinverse(inv_x)
  inv_x
}
