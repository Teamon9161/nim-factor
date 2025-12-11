import scinim/numpyarrays

# # Provide Vec1 helpers for NumpyArray so rolling_mean accepts it.
# proc len*[T](xs: NumpyArray[T]): int =
#   xs.len

proc uninit*[T](array: NumpyArray[T], len: int): NumpyArray[T] =
  initNumpyArray[T](@[len])
