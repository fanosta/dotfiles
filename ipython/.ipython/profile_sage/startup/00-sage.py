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

def _as_vec_gf2(x: int, bits: int) -> vector:
    v = vector(GF(2), bits)
    for i in range(bits):
        v[i] = (x >> i) & 1
    return v


def _linear_span(elements: set[int], bits: int) -> tuple[vector, VectorSpace]:
    iterator = iter(elements)

    offset = _as_vec_gf2(next(iterator), bits)

    vectors = []
    for x in iterator:
        vectors.append(_as_vec_gf2(x, bits) + offset)

    base_space = VectorSpace(GF(2), bits)
    return offset, base_space.subspace(vectors)


def _is_affine_space(solution_set: set[int], bits: int) -> bool:
    _, subspace = _linear_span(solution_set, bits)
    return len(subspace) == len(solution_set)

def is_planar(sbox: SBox) -> bool:
    if hasattr(sbox, '_planar'):
        return sbox._planar

    if sbox.differential_uniformity() <= 4:
        setattr(sbox, '_planar', False)
        return True

    if sbox.max_degree() <= 2 and sbox.inverse().max_degree() <= 2:
        setattr(sbox, '_planar', False)
        return True

    # ddt entries must be 0 or power of 2
    ddt = np.array(sbox.difference_distribution_table())
    if not np.all(ddt & (ddt - 1) == 0):
        setattr(sbox, '_planar', False)
        return False

    sbox_xddt = xddt(sbox).ravel()
    sbox_yddt = yddt(sbox).ravel()

    sbox_xddt = sbox_xddt[sbox_xddt != set()]
    sbox_yddt = sbox_yddt[sbox_yddt != set()]

    for input_set in sbox_xddt.ravel():
        if not _is_affine_space(input_set, sbox.input_size()):
            setattr(sbox, '_planar', False)
            return False

    for output_set in sbox_yddt.ravel():
        if not _is_affine_space(output_set, sbox.output_size()):
            setattr(sbox, '_planar', False)
            return False

    setattr(sbox, '_planar', True)
    return True

def undisturbed_bits(s):
    in_bits = s.input_size()
    out_bits = s.output_size()

    ddt = np.array(s.difference_distribution_table())

    for in_delta in range(1 << in_bits):
        out_deltas, = np.where(ddt[in_delta] > 0)
        always_zeros = np.bitwise_and.reduce(~out_deltas)
        always_ones = np.bitwise_and.reduce(out_deltas)

        out_delta = ''
        for i in range(out_bits):
            if always_zeros & (1 << i):
                out_delta = '0' + out_delta
            elif always_ones & (1 << i):
                out_delta = '1' + out_delta
            else:
                out_delta = '-' + out_delta

        print(f'{in_delta:0{in_bits}b} -> {out_delta}')

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
