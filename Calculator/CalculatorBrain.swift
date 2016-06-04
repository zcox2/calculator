//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Zachary Cox on 5/19/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    private var isPartialResult = false
    private var isCleared = true
    private var pendingImplicitOperation = false
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    func variableUpdated() {
        pendingImplicitOperation = false
        updateProgram()
        performOperation("=")
    }
    
    func setOperand(variable: String) {
        if let variableValue = variableValues[variable] { // variable is set to a value
            print("\(variable) set to \(variableValue)")
            accumulator = variableValue
            internalProgram.append(variable)
        } else { // variable is unset
            pendingImplicitOperation = true
            accumulator = 0.0
            internalProgram.append(variable)
            print("variable \(variable) accessed as zero, pendingImplicitOperation is \(pendingImplicitOperation)")
        }
    }
    
    private func updateProgram() {
        program = internalProgram
    }
    
    var variableValues: Dictionary<String, Double> = [:]
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI), // M_PI,
        "e" : Operation.Constant(M_E), // M_E,
        "√" : Operation.UnaryOperation(sqrt),
        "±" : Operation.UnaryOperation({ -$0 }),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals,
        "clear" : Operation.Clear,
        "clear display" : Operation.ClearDisplay
    ]
    
    private var unaryOperations: Set<String> = [
        "cos",
        "√"
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
        case ClearDisplay
    }
    
    func performOperation(symbol: String) {
        isCleared = false
        if let operation = operations[symbol] {
            switch operation {
                
            case .Constant(let value):
                accumulator = value
                internalProgram.append(symbol)
                
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                if isPartialResult == false {
                    internalProgram.insert("(", atIndex: 0)
                    internalProgram.append(")")
                }
                internalProgram.insert(symbol, atIndex: 0)
                
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                internalProgram.append(symbol)
                
            case .Equals:
                executePendingBinaryOperation()
                if pendingImplicitOperation {
                    var internalProgramString = ""
                    for item in internalProgram {
                        internalProgramString += String(item) + " "
                    }
                    print(internalProgramString)
                }
                
            case .Clear:
                clear()
                
            case .ClearDisplay:
                clearDisplay()
            }
        if pending == nil {isPartialResult = false
        } else {isPartialResult = true}
        }
    }
    
    private func clear() {
        isCleared = true
        pending = nil
        accumulator = 0
        internalProgram.removeAll()
        variableValues = [:]
    }
    
    func clearDisplay() {
        isCleared = true
        pending = nil
        accumulator = 0
        internalProgram.removeAll()
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
    
    private func sanitizeProgramArray(arrayOfOps: [AnyObject]) -> [AnyObject] {
        var mutableArrayOfOps = arrayOfOps
        var sanitizedArrayOfOps = [AnyObject]()
        var nonUnaryOpCounter = 0
        
        // -> removes unary operations and tags them onto end of mutable array
        // NOTE: calculator will not work as expected for multiple unary operations 
        //       when mixed with binary operations
        for op in mutableArrayOfOps {
            if unaryOperations.contains(String(op)) {
                print("unary operation \(op) recognized, placing to back of loop")
                mutableArrayOfOps.removeAtIndex(nonUnaryOpCounter)
                mutableArrayOfOps.append("=")
                mutableArrayOfOps.append(String(op))
            } else {
                nonUnaryOpCounter += 1
            }
        }
        
        // -> adds all items except parenthesis to sanitizedArrayOfOps
        for op in mutableArrayOfOps {
            if String(op) != "(" && String(op) != ")" {
                sanitizedArrayOfOps.append(op)
            }
            if String(op) == ")" {
                sanitizedArrayOfOps.append("=")
            }
        }
        for op in sanitizedArrayOfOps {
            print(String(op))
        }
        return sanitizedArrayOfOps
    }
    
    var program: PropertyList {
        get {
            // -> Adds indicators to end of display to show the status of the calculator
            var operationString = ""
            for op in internalProgram {
                operationString += String(op)
            }
            if isPartialResult == true {
                return operationString + ("...")
            } else if isCleared {
                return operationString + (" ")
            } else {
                return operationString + ("=")
            }
        }
        set {
            clearDisplay()
            if let arrayOfOps = newValue as? [AnyObject] {
                let sanitizedArrayOfOps = sanitizeProgramArray(arrayOfOps)
                for op in sanitizedArrayOfOps {
                    if let operand = op as? Double { // if it's an operand
                        setOperand(operand)
                    } else if let variableOrOperation = op as? String {
                        if variableValues[variableOrOperation] != nil { // if it's a variable
                            pendingImplicitOperation = false
                            setOperand(variableOrOperation)
                        } else if operations[variableOrOperation] != nil { // if it's an operation
                            let operation = variableOrOperation
                            performOperation(operation)
                        } else { // it's a variable, but is unset
                            setOperand(variableOrOperation)
                        }
                    }
                }
            }
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}