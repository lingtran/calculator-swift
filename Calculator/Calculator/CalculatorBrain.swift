//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ling Tran on 31/03/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Foundation

func factorialOf(x: Double) -> Double {
    var result: Double
    
    if [0, 1].contains(x){
        result = 1
    } else {
        result = factorialOf(x: x-1) * x
        
    }
    
    return result
    
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    private var internalProgram = [AnyObject]()
    
    private var descriptionHistory = [String]()
    
    private var description = ""
    
    private var isPartialResult: Bool = true
    
    private let ellipsis = "..."
    
    private let equalSign = "="
    
    func setOperand(operand: Double) {
        addOperandToDescriptionHistory(operand: String(operand))
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private func addOperandToDescriptionHistory(operand: String) {
        descriptionHistory.append(operand)
    }
    
    private func addOperationToDescriptionHistory(mathematicalSymbol: String) {
        if mathematicalSymbol == "√" && isPartialResult {
            formatMostRecentOperandWithSquareRootOperation()
        } else if mathematicalSymbol == "√" && isPartialResult == false {
            formatCurrentSequenceWithSquareRootOperation()
        } else if mathematicalSymbol != equalSign {
            descriptionHistory.append(mathematicalSymbol)
        } else {
            isPartialResult = false
        }
    }
    
    private func formatMostRecentOperandWithSquareRootOperation() {
        let indexOfLast = descriptionHistory.count - 1
        let mostRecentOperand = descriptionHistory[indexOfLast]
        
        descriptionHistory[indexOfLast] = "√(\(mostRecentOperand))"
    }
    
    private func formatCurrentSequenceWithSquareRootOperation() {
        descriptionHistory.insert("√(", at: 0)
        descriptionHistory.append(")")
    }
    
    private func prepareDescription() {
        description =  descriptionHistory.joined(separator: " ")
    }
    
    private func formatFinishingTouchesToDescription() -> String {
        if isPartialResult {
            return description + ellipsis
        } else {
            return description + equalSign
        }
    }
    
    func buildDescriptionWith(mathematicalSymbol: String) -> String {
        addOperationToDescriptionHistory(mathematicalSymbol: mathematicalSymbol)
        prepareDescription()
        return formatFinishingTouchesToDescription()
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(Double.pi),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "x^2": Operation.UnaryOperation({ pow($0, 2) }),
        "1/x": Operation.UnaryOperation({ 1 / $0 }),
        "x!": Operation.UnaryOperation(factorialOf),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "-": Operation.BinaryOperation({ $0 - $1 }),
        "^": Operation.BinaryOperation({ pow($0, $1) }),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperational(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
                
            }
        }
        
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperational(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}
