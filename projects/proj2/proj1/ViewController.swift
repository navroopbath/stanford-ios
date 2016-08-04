//
//  ViewController.swift
//  proj1
//
//  Created by Navroop Bath on 5/25/16.
//  Copyright © 2016 Navroop Bath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var sequenceOfOps: UILabel!
    private var opContainsVariable = false
    private var userIsInTheMiddleOfTyping = false
    private let MEMORYBUTTONVARIABLE = "M"
    
    // TODO should tapping "M" trigger touchDigit? This may cause problems if there is already an actual
    // digit in the display and the user then presses "M"
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction private func touchDecimal(sender: UIButton) {
        if isDecimalValid() {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + sender.currentTitle!
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction private func touchVariable(sender: UIButton) {
        if !userIsInTheMiddleOfTyping {
            display.text = sender.currentTitle!
            brain.setOperand(display.text!)
            opContainsVariable = true
        }
    }
    
    private var savedProgram : CalculatorBrain.PropertyList?
    
    @IBAction func saveVariable(sender: UIButton) {
        brain.variableValues[MEMORYBUTTONVARIABLE] = displayValue
        brain.program = brain.program
        displayValue = brain.result
    }
    
    private func isDecimalValid() -> Bool {
        return !display.text!.containsString(".")
    }

    private var displayValue : Double {
        get {
            return (Double(display.text!))!
        }
        set {
            display.text = String(newValue)
        }
    }

    
    var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping && !opContainsVariable { // setOperand already called if operation contains a variable
            brain.setOperand(displayValue)
        }
        userIsInTheMiddleOfTyping = false
        opContainsVariable = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        let description = brain.getDescription
        sequenceOfOps.text = description == "" ? " " : description
        displayValue = brain.result // TODO ensure that the brain updates result after performing the M operation and that the displayValue is updates
    }
}

