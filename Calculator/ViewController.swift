//
//  ViewController.swift
//  Calculator
//
//  Created by Zachary Cox on 5/19/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var userIsInTheMiddleOfTyping = false

    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit // append digit
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
            display.text = formatDisplayValue(newValue)
        }
    }

    private func formatDisplayValue(value: Double) -> String {
        var displayValueAsString = ""
        if String(value).hasSuffix(".0"){
            displayValueAsString = String(Int(value))
        } else {
            displayValueAsString = String(value)
        }
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 6
        displayValueAsString = formatter.stringFromNumber(NSNumber(double: value))!
        return displayValueAsString
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }

    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
        
    }
    
    @IBAction func setVar(sender: UIButton) {
        let variableName = String(sender.currentTitle!.characters.dropFirst())
        brain.variableValues[variableName] = displayValue
        brain.variableUpdated()
        updateDisplay()
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func getVar(sender: UIButton) {
        brain.setOperand(sender.currentTitle!)
        if brain.variableValues[sender.currentTitle!] != nil {
            displayValue = brain.result
        } else {
            displayValue = 0
        }
        updateDisplay()
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func clearDisplay(sender: UIButton) {
        updateDisplay()
    }
    
    @IBAction func undo(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            let currentDisplay = formatDisplayValue(displayValue)
                // updates displayValue to what the user sees
            
            var newDisplay = currentDisplay.characters
            newDisplay.removeLast()
            if let newDisplayAsDouble = Double(String(newDisplay)) {
                displayValue = newDisplayAsDouble
            } else {
                displayValue = 0
            }
        } else {
            performOperation(sender)
            updateDisplay()
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            displayValue = brain.result
        }
        updateDisplay()
    }
    
    private func updateDisplay() {
            descrip!.text! = String(brain.program)
            displayValue = brain.result
    }
    
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet weak var descrip: UILabel!

}

