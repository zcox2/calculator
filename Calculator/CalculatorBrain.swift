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
    
    func setOperand(variable: String) {
        if let variableValue = variableValues[variable] {
            print("\(variable) set to \(variableValue)")
            accumulator = variableValue
            internalProgram.append(variable)
            if pendingImplicitOperation {
                program = internalProgram
                print("tick")
            }
        } else {
            pendingImplicitOperation = true
            accumulator = 0.0
            internalProgram.append(variable)
            print("tock")
        }
        
    }
    
    func updateProgram() {
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
        "clear" : Operation.Clear
    ]
    
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
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
            }
            
        }
        
        if pending == nil {isPartialResult = false
        } else {isPartialResult = true}
        
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
    
    var program: PropertyList {
        get {
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
                for op in arrayOfOps {
                    
                    if let operand = op as? Double {
                        setOperand(operand)
                        print("\(op), loop 1")
                    } else if op as! String == "(" || op as! String == ")" {
                        
                    } else if let variableOrOperation = op as? String {
                        print("\(op), loop 2")
                        print("\(op), \(variableValues["/(op)"])")
                        if variableValues[variableOrOperation] != nil {
                            print("\(op), loop 2a")
                            pendingImplicitOperation = false
                            setOperand(variableOrOperation)
                            
                        } else if operations[variableOrOperation] != nil {
                            print("\(op) loop 2b")
                            let operation = variableOrOperation
                            performOperation(operation)
                        } else {
                            print("\(op), loop 2c")
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