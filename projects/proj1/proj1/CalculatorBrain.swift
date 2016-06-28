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
    private var description = ""
    private var isPartialResult : Bool {
        get {
            return pending != nil
        }
    }
    
    var getDescription : String {
        get {
            if (description == "") { return description }
            if (isPartialResult) {
                description += "..."
            } else {
                description += "="
            }
            return description
        }
    }
    
    func setOperand(operand : Double) {
        accumulator = operand
        if (!isPartialResult) {
            description = ""
        }
        description += String(operand)
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
        "±" : Operation.UnaryOperation({ -$0 }),
        "x²"  : Operation.UnaryOperation({ $0 * $0 }),
        "x⁻¹" : Operation.UnaryOperation({ 1 / $0 }),
        "=" : Operation.Equals,
        "AC": Operation.Clear
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Clear
        case Equals
    }
    
    func performOperation(symbol : String) {
        if let operation = operations[symbol] {
            switch (operation) {
            case .Constant(let value):
                description += symbol
                accumulator = value
            case .UnaryOperation(let function):
                addUnaryOperationDescription(symbol)
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                description += symbol
                performPendingBinaryOperation()
                pending = PendingBinaryOperation(firstOperand: accumulator, binaryOp: function)
            case .Equals:
                performPendingBinaryOperation()
            case .Clear:
                clear()
            }
        }
    }
    
    private func clear() {
        accumulator = 0
        description = ""
        pending = nil
    }
    
    private func addUnaryOperationDescription(Symbol : String) {
        if isPartialResult {
            let lastOperandIndex = description.endIndex.advancedBy(-1)
            description = description.substringToIndex(lastOperandIndex) + "\(symbol)(" + description.substringFromIndex(lastOperandIndex) + ")"
        } else {
            description = "\(symbol)(" + description + ")"
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