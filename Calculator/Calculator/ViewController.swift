//
//  ViewController.swift
//  Calculator
//
//  Created by Navroop Singh on 4/19/16.
//  Copyright © 2016 Navroop Bath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBOutlet private weak var display: UILabel!
    
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
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            userIsInTheMiddleOfTyping = false
            brain.setOperand(displayValue)
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
}

