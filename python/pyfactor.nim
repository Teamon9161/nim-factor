import ../rolling_tool
import scinim/numpyarrays
import nimpy

proc rolling_mean(array: NumpyArray[float]; window: int; min_periods: int = 0): NumpyArray[float] {.exportpy.} =
    array.rollingMean(window, min_periods)