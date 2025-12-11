import numpy as np
import teapy as tp
from pyfactor import rolling_mean


a = np.random.randn(10000000)

timeit rolling_mean(a, 20)
timeit tp.Expr(a).ts_mean(20, 10).eview()