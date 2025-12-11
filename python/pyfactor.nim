import ../rolling_tool
import ./numpy_array
import scinim/numpyarrays
import nimpy

proc rollingMeanPy(arr: NumpyArray[float]; window: int; min_periods: int = 0): NumpyArray[float] {.exportpy: "rolling_mean".} =
  rollingMean(arr, window, min_periods)
