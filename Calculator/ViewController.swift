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
            if String(newValue).hasSuffix(".0"){
                display.text = String(Int(newValue))
            } else {
                display.text = String(newValue)
            }
        }
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
        brain.variableValues[sender.currentTitle!] = displayValue
        userIsInTheMiddleOfTyping = false

    }
    
    @IBAction func getVar(sender: UIButton) {
        let variable = String(sender.currentTitle!.characters.dropFirst())
        if let variableValue = brain.variableValues[variable] {
            displayValue = variableValue
            brain.setOperand(variableValue)
        } else {
            displayValue = 0
            brain.setOperand(0)
        }
        userIsInTheMiddleOfTyping = false
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
        
    }
    
    @IBOutlet private weak var display: UILabel!


}

