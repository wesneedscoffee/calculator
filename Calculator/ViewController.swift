//
//  ViewController.swift
//  Calculator
//
//  Created by Wes Backous on 8/16/17.
//  Copyright © 2017 Wes Backous. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        
        set{
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        
        if(userIsInTheMiddleOfTyping){
            let textCurrentlyInDisplay = display.text!
            
            if digit == "." && textCurrentlyInDisplay.contains(".") {
                return
            }
            
            display.text = textCurrentlyInDisplay + digit
            
        }
        else{
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            
            userIsInTheMiddleOfTyping   = false
            
        }
        
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
    
}

