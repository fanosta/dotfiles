from sage.all import *

from sage.crypto.sbox import SBox
from sage.crypto import sboxes
from sage.misc.cachefunc import cached_method

from collections import Counter

import numpy as np

print(version())


def xddt(sbox: SBox):
    if (hasattr(sbox, '_xddt')):
        return sbox._xddt

    nrows = 1 << sbox.m
    ncols = 1 << sbox.n

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

    sbox._xddt = res
    return res


def yddt(sbox: SBox):
    if (hasattr(sbox, '_yddt')):
        return sbox._yddt

    nrows = 1 << sbox.m
    ncols = 1 << sbox.n

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

    sbox._yddt = res
    return res

def differential_spectrum(sbox: SBox):
    return  Counter(np.sort(sbox.ddt().flatten())[::-1])


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

    from PIL import Image
    img = Image.fromarray(bitmap == 0)
    img.show()
    return img


SBox.xddt = xddt
SBox.yddt = yddt

SBox.ddt = lambda s : np.array(s.difference_distribution_table())
SBox.lat = lambda s : np.array(s.linear_approximation_table())
SBox.bct = lambda s : np.array(s.boomerang_connectivity_table())

SBox.differential_spectrum = differential_spectrum
