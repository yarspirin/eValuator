//
//  EvaluatorBrain.swift
//  eValuator
//
//  Created by whoami on 18.08.16.
//  Copyright © 2016 Mountain Viewer. All rights reserved.
//

import Foundation

class EvaluatorBrain {
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    func performClear() {
        accumulator = 0.0
        pending = nil
    }
    
    func performEquals() {
        executePendingBinaryOperation()
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let foo): accumulator = foo(accumulator)
            case .BinaryOperation(let foo):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryOperation: foo, firstOperand: accumulator)
            }
        }
    }
    
    
    private var accumulator = 0.0
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation(Double -> Double)
        case BinaryOperation((Double, Double) -> Double)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "sin": Operation.UnaryOperation(sin),
        "cos": Operation.UnaryOperation(cos),
        "tan": Operation.UnaryOperation(tan),
        "asin": Operation.UnaryOperation(asin),
        "acos": Operation.UnaryOperation(acos),
        "atan": Operation.UnaryOperation(atan),
        "ln": Operation.UnaryOperation(log),
        "√": Operation.UnaryOperation(sqrt),
        "inv": Operation.UnaryOperation({ 1 / $0 }),
        "±": Operation.UnaryOperation({ -$0 }),
        "pow": Operation.BinaryOperation(pow),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "-": Operation.BinaryOperation({ $0 - $1 }),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 })
        
    ]
    
    private struct PendingBinaryOperationInfo {
        var binaryOperation: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}