# Copyright 2017 UniCredit S.p.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import unittest, neo/dense

suite "initializaton of vectors":
  test "zero vectors":
    let v = zeros(5)
    check v == @[0.0, 0.0, 0.0, 0.0, 0.0]
  test "one vectors":
    let v = ones(3)
    check v == @[1.0, 1.0, 1.0]
  test "constant vectors":
    let v = constantVector(4, 2.3)
    check v == @[2.3, 2.3, 2.3, 2.3]
  test "vectors generated by a proc":
    let v = makeVector(4, proc(i: int): float64 = (i * i).float64)
    check v == @[0.0, 1.0, 4.0, 9.0]
  test "vectors generated by an expression":
    let
      v = makeVector(4, proc(i: int): float64 = (i * i).float64)
      w = makeVectorI[float64](4, (i * i).float64)
    check v == w
  test "vectors generated randomly":
    let v = randomVector(6)
    check len(v) == 6
    for i in 0 .. 5:
      check v[i] >= 0
      check v[i] <= 1

suite "initializaton of 32-bit vectors":
  test "zero vectors":
    let v = zeros(5, float32)
    check v == @[0'f32, 0, 0, 0, 0]
  test "one vectors":
    let v = ones(3, float32)
    check v == @[1'f32, 1'f32, 1'f32]
  test "constant vectors":
    let v = constantVector(4, 2.5'f32)
    check v == @[2.5'f32, 2.5'f32, 2.5'f32, 2.5'f32]
  test "vectors generated by a proc":
    let v = makeVector(4, proc(i: int): float32 = (i * i).float32)
    check v == @[0'f32, 1'f32, 4'f32, 9'f32]
  test "vectors generated by an expression":
    let
      v = makeVector(4, proc(i: int): float32 = (i * i).float32)
      w = makeVectorI[float32](4, (i * i).float32)
    check v == w
  test "vectors generated randomly":
    let v = randomVector(6, max = 1'f32)
    check len(v) == 6
    for i in 0 .. 5:
      check v[i] >= 0
      check v[i] <= 1

suite "initializaton of matrices":
  test "zero matrices":
    let m = zeros(3, 2)
    check dim(m) == (3, 2)
    check m[0, 0] == 0.0
    check m[1, 0] == 0.0
    check m[2, 0] == 0.0
    check m[0, 1] == 0.0
    check m[1, 1] == 0.0
    check m[2, 1] == 0.0
  test "one matrices":
    let m = ones(2, 2)
    check dim(m) == (2, 2)
    check m[0, 0] == 1.0
    check m[1, 0] == 1.0
    check m[0, 1] == 1.0
    check m[1, 1] == 1.0
  test "constant matrices":
    let m = constantMatrix(2, 3, 1.5)
    check dim(m) == (2, 3)
    check m[0, 0] == 1.5
    check m[1, 0] == 1.5
    check m[0, 1] == 1.5
    check m[1, 1] == 1.5
    check m[0, 2] == 1.5
    check m[1, 2] == 1.5
  test "identity matrices":
    let m = eye(4)
    check dim(m) == (4, 4)
    for t, v in m:
      let (i, j) = t
      if i == j:
        check v == 1.0
      else:
        check v == 0.0
  test "matrices generated by a proc":
    let m = makeMatrix(3, 5, proc(i, j: int): float64 = (i * j).float64)
    check dim(m) == (3, 5)
    check m[0, 2] == 0.0
    check m[1, 1] == 1.0
    check m[2, 3] == 6.0
    check m[2, 4] == 8.0
  test "matrices generated by an expression":
    let
      m = makeMatrix(3, 5, proc(i, j: int): float64 = (i * j).float64)
      n = makeMatrixIJ(float64, 3, 5, (i * j).float64)
    check m == n
  test "matrices generated by a sequence":
    let
      a = @[
        @[1.2, 3.2, 2.6],
        @[2.3, 2.8, -1.45],
        @[-1.2, 3.1, 3.3]
      ]
      m = matrix(a)
    check dim(m) == (3, 3)
    for i in 0 .. 2:
      for j in 0 .. 2:
        check m[i, j] == a[i][j]
  test "matrices generated randomly":
    let m = randomMatrix(3, 4)
    check dim(m) == (3, 4)
    for i in 0 .. 2:
      for j in 0 .. 3:
        check m[i, j] >= 0
        check m[i, j] <= 1

suite "initializaton of 32-bit matrices":
  test "zero matrices":
    let m = zeros(3, 2, float32)
    check dim(m) == (3, 2)
    check m[0, 0] == 0'f32
    check m[1, 0] == 0'f32
    check m[2, 0] == 0'f32
    check m[0, 1] == 0'f32
    check m[1, 1] == 0'f32
    check m[2, 1] == 0'f32
  test "one matrices":
    let m = ones(2, 2, float32)
    check dim(m) == (2, 2)
    check m[0, 0] == 1'f32
    check m[1, 0] == 1'f32
    check m[0, 1] == 1'f32
    check m[1, 1] == 1'f32
  test "constant matrices":
    let m = constantMatrix(2, 3, 1.5'f32)
    check dim(m) == (2, 3)
    check m[0, 0] == 1.5'f32
    check m[1, 0] == 1.5'f32
    check m[0, 1] == 1.5'f32
    check m[1, 1] == 1.5'f32
    check m[0, 2] == 1.5'f32
    check m[1, 2] == 1.5'f32
  test "identity matrices":
    let m = eye(4, float32)
    check dim(m) == (4, 4)
    for t, v in m:
      let (i, j) = t
      if i == j:
        check v == 1'f32
      else:
        check v == 0'f32
  test "matrices generated by a proc":
    let m = makeMatrix(3, 5, proc(i, j: int): float32 = (i * j).float32)
    check dim(m) == (3, 5)
    check m[0, 2] == 0'f32
    check m[1, 1] == 1'f32
    check m[2, 3] == 6'f32
    check m[2, 4] == 8'f32
  test "matrices generated by an expression":
    let
      m = makeMatrix(3, 5, proc(i, j: int): float32 = (i * j).float32)
      n = makeMatrixIJ(float32, 3, 5, (i * j).float32)
    check m == n
  test "matrices generated by a sequence":
    let
      a = @[
        @[1.2'f32, 3.2'f32, 2.6'f32],
        @[2.3'f32, 2.8'f32, -1.45'f32],
        @[-1.2'f32, 3.1'f32, 3.3'f32]
      ]
      m = matrix(a)
    check dim(m) == (3, 3)
    for i in 0 .. 2:
      for j in 0 .. 2:
        check m[i, j] == a[i][j]
  test "matrices generated randomly":
    let m = randomMatrix(3, 4, max = 1'f32)
    check dim(m) == (3, 4)
    for i in 0 .. 2:
      for j in 0 .. 3:
        check m[i, j] >= 0
        check m[i, j] <= 1