from sage.all import *

from sage.crypto.sbox import SBox
from sage.crypto import sboxes
from sage.misc.cachefunc import cached_method

from collections import Counter

import PIL
from PIL import Image

import numpy as np

from math import log2

print(version())


def xddt(sbox: SBox):
    if (hasattr(sbox, '_xddt')):
        return sbox._xddt

    nrows = 1 << sbox.input_size()
    ncols = 1 << sbox.output_size()

    res = [[set() for _ in range(ncols)] for _ in range(nrows)]
    res = np.zeros((nrows, ncols), dtype=object)
    for i in range(nrows):
        for j in range(nrows):
            res[i, j] = set()

    for x in range(nrows):
        sx = sbox[x]
        for y in range(nrows):
            sy = sbox[y]
            res[x ^ y, sx ^ sy].add(x)

    setattr(sbox, '_xddt', res)
    return res


def yddt(sbox: SBox):
    if (hasattr(sbox, '_yddt')):
        return sbox._yddt

    nrows = 1 << sbox.input_size()
    ncols = 1 << sbox.output_size()

    res = [[set() for _ in range(ncols)] for _ in range(nrows)]
    res = np.zeros((nrows, ncols), dtype=object)
    for i in range(nrows):
        for j in range(nrows):
            res[i, j] = set()

    for x in range(nrows):
        sx = sbox[x]
        for y in range(nrows):
            sy = sbox[y]
            res[x ^ y, sx ^ sy].add(sx)

    setattr(sbox, '_yddt', res)
    return res

def differential_spectrum(sbox: SBox):
    ddt = np.array(sbox.difference_distribution_table())
    return  Counter(np.sort(ddt.ravel())[::-1])


def print_bitmap(bitmap: np.array, displ = lambda x : '# ' if x else '  '):
    if len(bitmap.shape) != 2:
        raise ValueError('bitmap must be 2d array')

    for row in range(bitmap.shape[0]):
        for col in range(bitmap.shape[1]):
            print(displ(bitmap[row, col]), end='')
        print()

def render_bitmap(bitmap: np.array):
    if len(bitmap.shape) != 2:
        raise ValueError('bitmap must be 2d array')

    img = Image.fromarray(bitmap)
    img.show()
    return img

def render_bitmap_log(bitmap: np.array, factor: float):
    p = bitmap / np.max(bitmap)
    imgbuf = np.zeros_like(bitmap, dtype=np.int32)
    imgbuf[p > 0] = 255 + factor * np.log2(p[p > 0])
    img = Image.fromarray(imgbuf, mode="L")
    img.show()
    return img


sboxes.DEFAULT = SBox(int(x, 16) for x in "037ed4a9cf18b265")
sboxes.BAKSHEESH = SBox(int(x, 16) for x in "306DB58ECF924A71")
sboxes.SPEEDY = SBox([8, 0, 9, 3, 56, 16, 41, 19, 12, 13, 4, 7, 48, 1, 32, 35,
                      26, 18, 24, 50, 62, 22, 44, 54, 28, 29, 20, 55, 52, 5,
                      36, 39, 2, 6, 11, 15, 51, 23, 33, 21, 10, 27, 14, 31, 49,
                      17, 37, 53, 34, 38, 42, 46, 58, 30, 40, 60, 43, 59, 47,
                      63, 57, 25, 45, 61])
sboxes.WARP = SBox(int(x, 16) for x in "cad3ebf789150246")

# SBox.xddt = xddt
# SBox.yddt = yddt

# SBox.ddt = lambda s : np.array(s.difference_distribution_table())
# SBox.lat = lambda s : np.array(s.linear_approximation_table())
# SBox.bct = lambda s : np.array(s.boomerang_connectivity_table())

# SBox.differential_spectrum = differential_spectrum
