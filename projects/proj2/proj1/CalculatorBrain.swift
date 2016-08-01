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
    private var lastOperandIndex : String.CharacterView.Index?
    private var internalProgram = [AnyObject]()
        
    var getDescription : String {
        get {
            if (description == "") { return description }
            var descriptionWithStatus = description
            if (isPartialResult) {
                descriptionWithStatus += "..."
            } else {
                descriptionWithStatus += "="
            }
            return descriptionWithStatus
        }
    }
    
    func setOperand(operand : Double) {
        description += String(operand)
        internalProgram.append(operand)
        setOperandForDouble(operand)
    }
    
    func setOperand(variableName : String) {
        description += variableName
        internalProgram.append(variableName)
        if let variableValue = variableValues[variableName] {
            setOperandForDouble(variableValue)
        } else {
            setOperandForDouble(0.0) // Use 0.0 as the default value for an unset variable
        }
    }
    
    private func setOperandForDouble(operand : Double) {
        accumulator = operand
        if (!isPartialResult) {
            description = ""
        }
        lastOperandIndex = description.endIndex - String(operand).size
    }
    
    var variableValues : Dictionary<String, Double> = [:]
    
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
            internalProgram.append(symbol)
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
        internalProgram.removeAll()
    }
    
    private func addUnaryOperationDescription(opSymbol : String) {
        if isPartialResult {
            description = description.substringToIndex(lastOperandIndex!) + "\(opSymbol)(" + description.substringFromIndex(lastOperandIndex!) + ")"
        } else {
            description = "\(opSymbol)(" + description + ")"
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
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return internalProgram // returned as a copy since it is a value type
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    
    var result : Double {
        get {
            return accumulator
        }
    }
}