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
        let variableName = String(sender.currentTitle!.characters.dropFirst())
        brain.variableValues[variableName] = displayValue
        userIsInTheMiddleOfTyping = false
        // brain.updateProgram()
    }
    
    @IBAction func getVar(sender: UIButton) {
        if brain.variableValues[sender.currentTitle!] != nil {
            brain.setOperand(sender.currentTitle!)
            displayValue = brain.result
            
        } else {
            displayValue = 0
            brain.setOperand(sender.currentTitle!)
        }
        updateDisplay()
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func clearDisplay(sender: UIButton) {
        brain.clearDisplay()
        updateDisplay()
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
    }
    
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet weak var descrip: UILabel!

}

