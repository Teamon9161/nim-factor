import ../rolling_tool
import ./numpy_array
import scinim/numpyarrays
import nimpy

# proc toContiguous[T](arr: NumpyArray[T]): NumpyArray[T] =
#   ## Always materialize a contiguous view via numpy (avoids scinim's type mismatch).
#   let np = pyImport("numpy")
#   initNumpyArray[T](np.ascontiguousarray(arr.obj()))

proc rollingMeanPy(arr: NumpyArray[float]; window: int; min_periods: int = 0): NumpyArray[float] {.exportpy: "rolling_mean".} =
  ## Fast path: force contiguous buffer once, then iterate with raw pointers.
  # let input = arr.toContiguous()
  let input = arr
  let n = input.len
  var rm = initRollingMeanManaged(window, min_periods)

  var res = uninit[float](input, n)
  let src = input.toUnsafeView()
  let dst = res.toUnsafeView()

  var i = 0
  while i < n:
    dst[i] = rm.update(src[i])
    inc i
  res
