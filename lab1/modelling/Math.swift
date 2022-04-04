//
//  Math.swift
//  modelling
//
//  Created by Kirill Diordiev on 11.03.2022.
//

import Foundation
import swift_algo

struct Matrix<T> {
    let rows: Int, cols: Int
    var grid: [T]
    
    init(rows: Int, cols: Int, defaultValue: T) {
        self.rows = rows
        self.cols = cols
        grid = Array(repeating: defaultValue, count: rows * cols)
    }
    
    func indexIsValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }
    
    subscript(row: Int, col: Int) -> T {
        get {
            assert(indexIsValid(row: row, col: col), "Index out of range")
            return grid[(row * cols) + col]
        }
        
        set {
            assert(indexIsValid(row: row, col: col), "Index out of range")
            grid[(row * cols) + col] = newValue
        }
    }
}

func picardResult(xs: Float, xe: Float, ys: Float, h: Float) -> Matrix<Float> {
    
    var res : UnsafeMutablePointer<mat>?
    let n: Int32 = Int32(ceilf(fabsf(xe - xs) / h))
    
    res = algo_picard(xs, h, n)
    
    let rows: Int = Int(res?.pointee.rows ?? 0), cols: Int = Int(res?.pointee.cols ?? 0)
    
    var results: Matrix<Float> = Matrix<Float>(rows: rows, cols: cols, defaultValue: 0.0)
    
    for (i, row) in UnsafeBufferPointer(start: res?.pointee.data, count: rows).enumerated() {
        for (j, elem) in UnsafeBufferPointer(start: row, count: cols).enumerated() {
            results[i, j] = elem
        }
    }
    
    free_matrix(res)
    
    return results
    
}

func equation(x: Float, u: Float) -> Float {
    return x * x + u * u
}


func rungeKutteKuttaResult(xs: Float, xe: Float, ys: Float, a: Float, h: Float) -> Array<Float> {
    
    var res : UnsafeMutablePointer<arr>?
    let n: Int32 = Int32(ceilf(fabsf(xe - xs) / h))
    
    var results = Array<Float>()
    
    res = algo_runge_kutta(xs, ys, a, h, n, equation);
    
    let count = Int(res?.pointee.size ?? 0)
    
    for elem in UnsafeBufferPointer(start: res?.pointee.data, count: count) {
        results.append(elem)
    }
    
    free_array(res)
    
    return results
}

func eulerResult(xs: Float, xe: Float, ys: Float, h: Float) -> Array<Float> {
    var res: UnsafeMutablePointer<arr>?
    let n: Int32 = Int32(ceilf(fabsf(xe - xs) / h))
    
    var results = Array<Float>()
    
    res = algo_euler(xs, ys, h, n, equation)
    
    let count = Int(res?.pointee.size ?? 0)
    
    for elem in UnsafeBufferPointer(start: res?.pointee.data, count: count) {
        results.append(elem)
    }
    
    free_array(res)
    
    
    return results
}
