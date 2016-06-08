//
//  CalculatorBrain.swift
//  proj1
//
//  Created by Navroop Bath on 6/3/16.
//  Copyright © 2016 Navroop Bath. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var pending : PendingBinaryOperation?
    
    func setOperand(operand : Double) {
        accumulator = operand
    }
    
    private var operations : Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "cos" : Operation.UnaryOperation(cos),
        "√" : Operation.UnaryOperation(sqrt),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals,
        "." : Operation.Decimal
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Decimal
    }
    
    func performOperation(symbol : String) {
        if let operation = operations[symbol] {
            switch (operation) {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                performPendingBinaryOperation()
                pending = PendingBinaryOperation(firstOperand: accumulator, binaryOp: function)
            case .Equals:
                performPendingBinaryOperation()
            case .Decimal:
                print("Hello Decimal")
            }
        }
    }

    private func performPendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryOp(pending!.firstOperand, accumulator)
        }
        pending = nil
    }
    
    struct PendingBinaryOperation {
        var firstOperand : Double
        var binaryOp : (Double, Double) -> Double
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }
}