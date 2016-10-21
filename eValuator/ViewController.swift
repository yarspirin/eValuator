//
//  ViewController.swift
//  eValuator
//
//  Created by whoami on 18.08.16.
//  Copyright © 2016 Mountain Viewer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var evaluatorBrain = EvaluatorBrain()
    
    @IBOutlet weak var display: UILabel!
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    var isUserInTheMiddleOfTyping = false
    
    func updateDisplayValue() {
        displayValue = evaluatorBrain.result
    }
    
    @IBAction func touchDigit(sender: UIButton) {
        if isUserInTheMiddleOfTyping {
            display.text = display.text! + sender.currentTitle!
        } else {
            display.text = sender.currentTitle!
            isUserInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func touchClear(sender: UIButton) {
        evaluatorBrain.performClear()
        updateDisplayValue()
        isUserInTheMiddleOfTyping = false
        
    }
    
    @IBAction func touchEquals(sender: UIButton) {
        if isUserInTheMiddleOfTyping {
            evaluatorBrain.setOperand(displayValue)
            isUserInTheMiddleOfTyping = false
        }
        
        evaluatorBrain.performEquals()
        updateDisplayValue()
    }
    
    @IBAction func touchOperation(sender: UIButton) {
        if isUserInTheMiddleOfTyping {
            evaluatorBrain.setOperand(displayValue)
            isUserInTheMiddleOfTyping = false
        }
        
        if let symbol = sender.currentTitle {
            evaluatorBrain.performOperation(symbol)
        }
        
        updateDisplayValue()
    }
    
    @IBAction func touchPeriod(sender: UIButton) {
        if isUserInTheMiddleOfTyping && !display.text!.containsString(".") {
            display.text = display.text! + "."
        }
    }
    
}

