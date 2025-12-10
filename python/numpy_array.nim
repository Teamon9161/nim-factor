import ../vec
export vec
import scinim/numpyarrays

proc initOut*[T](xs: NumpyArray[T]): NumpyArray[float] =
  initNumpyArray[float](xs.shape)

proc ensure1D*[T](xs: NumpyArray[T]) =
  if xs.shape.len != 1:
    raise newException(ValueError, "rollingMean only supports 1-D NumpyArray")
