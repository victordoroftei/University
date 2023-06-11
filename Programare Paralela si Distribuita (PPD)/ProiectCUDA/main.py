import cv2

from numba import vectorize
from timeit import default_timer as timer

import numpy as np


@vectorize(["int32(int32, int32, int32)"], target='cuda')
def calcRed(R, G, B):
    val = R * 0.1 + G * 0.2 + B * 0.3

    if val > 255:
        return 255

    return val


@vectorize(["int32(int32, int32, int32)"], target='cuda')
def calcGreen(R, G, B):
    val = R * 0.4 + G * 0.5 + B * 0.6

    if val > 255:
        return 255

    return val


@vectorize(["int32(int32, int32, int32)"], target='cuda')
def calcBlue(R, G, B):
    val = R * 0.7 + G * 0.8 + B * 0.9

    if val > 255:
        return 255

    return val


if __name__ == "__main__":
    inputFileName = "img"
    imageArray = cv2.imread(f"{inputFileName}.png")
    noPixels = len(imageArray) * len(imageArray[0])

    redPixels = np.empty(shape=noPixels, dtype=np.int32)
    greenPixels = np.empty(shape=noPixels, dtype=np.int32)
    bluePixels = np.empty(shape=noPixels, dtype=np.int32)

    startTime = timer()

    currentPixelIndex = 0
    for line in imageArray:
        for pixel in line:
            bluePixels[currentPixelIndex] = pixel[0]
            greenPixels[currentPixelIndex] = pixel[1]
            redPixels[currentPixelIndex] = pixel[2]
            currentPixelIndex += 1

    newBlueValues = calcBlue(redPixels, greenPixels, bluePixels)
    newGreenValues = calcGreen(redPixels, greenPixels, bluePixels)
    newRedValues = calcRed(redPixels, greenPixels, bluePixels)

    currentPixelIndex = 0
    for i in range(0, len(imageArray)):
        for j in range(0, len(imageArray[0])):
            imageArray[i][j] = [newBlueValues[currentPixelIndex], newGreenValues[currentPixelIndex], newRedValues[currentPixelIndex]]
            currentPixelIndex += 1

    endTime = timer() - startTime
    print(endTime)

    cv2.imwrite(f"{inputFileName}-filtered.png", imageArray)
