//
//  ViewController.swift
//  Calculator
//
//  Created by Ling Tran on 30/03/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var descriptionField: UILabel!
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping: Bool = false
    
    private let decimalPoint = "."
    
    @IBAction private func touchDigit(_ sender: UIButton ) {
        let digit = sender.currentTitle!
       
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            
            if digit == decimalPoint && textCurrentlyInDisplay.contains(decimalPoint) {
                display.text = textCurrentlyInDisplay
            } else {
                display.text = textCurrentlyInDisplay + digit
            }
            
        } else {
            display.text = digit
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
    
    private func resetCalculator() {
        displayValue = 0.0
        descriptionField.text = String(0.0)
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            descriptionField.text = brain.buildDescriptionWith(mathematicalSymbol:mathematicalSymbol)
            brain.performOperational(symbol: mathematicalSymbol)
        }
        
        displayValue = brain.result
    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain.performOperational(symbol: sender.currentTitle!)
        resetCalculator()
    }
}

