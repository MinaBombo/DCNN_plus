import sys

import numpy as np
import cv2

polling = True

filter_data = np.array([[0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0],
                        [0, 0, 1, -1, 0],
                        [0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0]], dtype='int8')
filter_data = filter_data.flatten()
image_data = cv2.imread('standard_test_images/256.tif', cv2.IMREAD_GRAYSCALE).flatten()//2

if polling:
    all_data = image_data.tolist()
else:
    all_data = filter_data.tolist() + image_data.tolist()

with open(sys.argv[1], 'w') as file:
    print('// memory data file (do not edit the following line - required for mem load use)',
          '// instance=/system/Ram_Instance/ram_memory_s',
          '// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1',
          sep='\n', file=file)

    for i in range(129069):
        print(i, ':', sep='', end=' ', file=file)
        if i < len(all_data):
            print(all_data[i], file=file)
        else:
            print(0, file=file)
