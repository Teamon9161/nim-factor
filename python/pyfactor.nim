import ../rolling_tool
import ./numpy_array
import scinim/numpyarrays
import nimpy

proc rollingMeanPy(array: NumpyArray[float]; window: int; min_periods: int = 0): NumpyArray[float] =
  rolling_tool.rollingMean(array, window, min_periods)

# Export to Python name rolling_mean, mapping to rollingMeanPy implementation.
exportpy rolling_mean, rollingMeanPy
