import ../rolling_tool
import ./numpy_array
import scinim/numpyarrays
import nimpy

# proc toContiguous[T](arr: NumpyArray[T]): NumpyArray[T] =
#   ## Always materialize a contiguous view via numpy (avoids scinim's type mismatch).
#   let np = pyImport("numpy")
#   initNumpyArray[T](np.ascontiguousarray(arr.obj()))

proc rollingMeanPy(arr: NumpyArray[float]; window: int; min_periods: int = 0): NumpyArray[float] {.exportpy: "rolling_mean".} =
  ## Full semantics: honor min_periods and NaN handling; external window management.
  let input = arr
  let n = input.len
  var rm = initRollingMean(window, min_periods)

  var res = uninit[float](input, n)
  let src = input.toUnsafeView()
  let dst = res.toUnsafeView()

  var i = 0
  while i < n:
    let oldVal = if i >= window: src[i - window] else: NaN
    dst[i] = rm.update(src[i], oldVal)
    inc i
  res
