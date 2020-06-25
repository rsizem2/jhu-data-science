## Uses caching to speed up repeated computations of matrix 
## inverses. We associate with a matrix x the list created
## by makeCacheMatrix(x). The first time cacheSolve is called 
## with makeCacheMatrix(x), we apply solve() to find the matrix
## inverse, subsequent calls use the cached value from first call

## Creates a list of functions from a matrix x:
## set - sets value of matrix
## get - gets value of matrix
## setinv - set the value of matrix inverse of x
## getinv - get the value of the matrix inverse of x

makeCacheMatrix <- function(x = matrix()) {
    z <- NULL
    set <- function(y) {
        x <<- y
        z <<- NULL
    }
    get <- function() x
    setinv <- function(inv) z <<- inv
    getinv <- function() z
    list(set = set, get = get,
         setinv = setinv,
         getinv = getinv)
}


## Determines the matrix inverse of x, first by checking 
## whether this inverse has already been determined, otherwise
## calculates it via the Solve function and caches it for potential
## later usage in subsequent calls to

cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    z <- x$getinv()
    if(!is.null(z)) {
        message("getting cached data")
        return(z)
    }
    data <- x$get()
    z <- solve(data, ...)
    x$setinv(z)
    z
}
