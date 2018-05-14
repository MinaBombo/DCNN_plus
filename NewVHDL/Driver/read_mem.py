import sys

import numpy as np
from scipy import signal
import cv2

stride = 2
polling = True

def strideConv(arr, arr2, s):
    return signal.convolve2d(arr, arr2[::-1, ::-1], mode='valid')[::s, ::s]


original = cv2.imread('standard_test_images/256.tif', cv2.IMREAD_GRAYSCALE) // 2
original_trimmed = original.T[2:-2].T[2:-2]

start_address = 65561

if stride == 1:
    image_dimensions = (252, 252)
else:
    image_dimensions = (126, 126)

image_size = image_dimensions[0]*image_dimensions[1]

convolved_hw = np.empty(image_size, dtype='int8')
with open(sys.argv[1], 'r') as file:
    for line in file:
        if line.startswith('/'):
            continue
        line = line.replace(' ', '')
        pair = line.split(':')
        index = int(pair[0]) - start_address
        value = int(pair[1])
        if index in range(image_size):
            convolved_hw[index] = value
convolved_hw = convolved_hw.reshape(image_dimensions)

if polling:
    filter_data = np.ones((5, 5), dtype='int8')
    convolved_sw = strideConv(original, filter_data, stride)
    convolved_sw //= 32
else:
    filter_data = np.array([[0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0],
                            [0, 0, 1, -1, 0],
                            [0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0]], dtype='int8')
    convolved_sw = strideConv(original, filter_data, stride)

print((convolved_hw == convolved_sw).all())

cv2.imwrite('original.png', original_trimmed)
cv2.imwrite('convolved_hw.png', convolved_hw)
cv2.imwrite('convolved_sw.png', convolved_sw)
