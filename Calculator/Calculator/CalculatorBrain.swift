//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Navroop Singh on 5/1/16.
//  Copyright © 2016 Navroop Bath. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    var result : Double {
        get {
            return 0.0
        }
    }
    
    var operations : Dictionary<String, Operation> = [
        "π" : Operation.Constant,
        "e" : Operation.Constant,
        "√" : Operation.UnaryOperation,
        "cos" : Operation.UnaryOperation
    ]
    
    enum Operation {
        case Constant
        case UnaryOperation
        case BinaryOperation
        case Equals
    }
    
    func setOperand(operand : Double) {
        accumulator = operand
    }
    
    func performOperation(symbol : String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant : break
            case .UnaryOperation : break
            case .BinaryOperation : break
            case .Equals : break
            }
        }
    }
    
}