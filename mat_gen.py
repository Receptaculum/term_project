# Matrix Generator

import numpy as np
from scipy.signal import convolve2d

a = np.round(np.random.rand(4, 4)*255)
f = np.round(np.random.rand(3, 3)*255)

result = np.uint8(convolve2d(a, f, mode='valid'))

print("input")
print(a, "\n")
print("filter")
print(f, "\n")
print("output")
print(result)