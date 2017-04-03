//
//  ViewController.swift
//  Calculator
//
//  Created by Ling Tran on 30/03/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping: Bool = false
    
    private let decimalPoint = "."
    
    @IBAction private func touchDigit(_ sender: UIButton ) {
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        
        if userIsInTheMiddleOfTyping {
            if digit != decimalPoint || display.text!.range(of: decimalPoint) == nil {
                display.text = textCurrentlyInDisplay + digit
            } else if display.text!.range(of: decimalPoint) != nil {
                display.text = textCurrentlyInDisplay + digit
            }
            else {
                display.text = textCurrentlyInDisplay + "."
            }
            
        } else {
            if digit == decimalPoint {
                display.text = "\(textCurrentlyInDisplay).\(digit)"
            } else {
                display.text = digit
            }
        }
        
        userIsInTheMiddleOfTyping = true
        
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
        
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperational(symbol: mathematicalSymbol)
        }
        
        displayValue = brain.result
    }
    
}

