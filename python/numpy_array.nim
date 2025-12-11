import ../vec
export vec
import scinim/numpyarrays

# Provide Vec1 helpers for NumpyArray so rolling_mean accepts it.
proc len*[T](xs: NumpyArray[T]): int =
  xs.len

proc initOut*[T](_: typedesc[NumpyArray[T]], len: int): NumpyArray[T] =
  initNumpyArray[T](@[len])

proc ensure1D*[T](xs: NumpyArray[T]) =
  if xs.shape.len != 1:
    raise newException(ValueError, "rollingMean only supports 1-D NumpyArray")
