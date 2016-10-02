//
//  ViewController.swift
//  fast-math
//
//  Created by Vicky Tang on 7/27/16.
//  Copyright © 2016 Vicky Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var operatorLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var negativeBtn: UIButton!
    @IBOutlet weak var incorrect: UILabel!
    @IBOutlet weak var correct: UILabel!
    
    var input = ""
    var result = 0
    var expression: NSExpression = NSExpression(format:"1+2")
    
    var randomOperator: UInt32 = 0
    var randomNumber: UInt32 = 0
    
    var nextOperator = ""
    var firstNum = 0
    var secondNum = 0
    
    var divisor = 0
    var dividend = 0
    var quotient = 0

    var hasNegative = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playPressed(btn: UIButton!) {
        titleLbl.hidden = true
        playBtn.hidden = true
        exitBtn.hidden = false
        self.view.viewWithTag(10)?.hidden = false
        nextQuestion()
    }
    
    @IBAction func exitPressed(btn: UIButton!) {
        input = "0"
        updateAnswerLbl()
        
        exitBtn.hidden = true
        self.view.viewWithTag(10)?.hidden = true
        titleLbl.hidden = false
        playBtn.hidden = false
        correct.hidden = true
        incorrect.hidden = true
    }

    @IBAction func numberPressed(btn: UIButton!) {
        input += "\(btn.tag)"
        updateAnswerLbl()
    }
    
    @IBAction func negativePressed(btn: UIButton!) {
        if hasNegative {
            input = String(input.characters.dropFirst())
            hasNegative = false
        } else {
            input = "-\(input)"
            hasNegative = true
        }
        updateAnswerLbl()
    }
    
    @IBAction func clearPressed(btn: UIButton!) {
        refresh()
    }
    
    @IBAction func backspacePressed(btn: UIButton!) {
        if input != "" {
            input = input.substringToIndex(input.endIndex.predecessor())
            updateAnswerLbl()
        } else {
            answerLbl.text = "0"
        }
    }
    
    @IBAction func enterPressed(btn: UIButton!) {
        if checkAnswer() {
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.refresh()
                self.nextQuestion()
            }
        }
    }
    
    func updateAnswerLbl() {
        answerLbl.text = input
    }
    
    func checkAnswer() -> Bool {
        if input != "" {
            expression = NSExpression(format:operatorLbl.text!)
            result = expression.expressionValueWithObject(nil, context: nil) as! Int
            
            if Int(input)! == result {
                correct.hidden = false
                incorrect.hidden = true
                
                return true
            } else {
                correct.hidden = true
                incorrect.hidden = false
                
                return false
            }
        }
        return false
    }
    
    func refresh() {
        correct.hidden = true
        incorrect.hidden = true

        input = ""
        answerLbl.text = "0"
    }
    
    func nextQuestion() {
        generateOperator()
        
        if randomOperator != 3 {
            generateNums()
            
            operatorLbl.text = "\(firstNum)\(nextOperator)\(secondNum)"
        } else {
            generateDivisionEq()
            operatorLbl.text = "\(dividend)\(nextOperator)\(divisor)"
        }
    }
    
    func generateOperator() {
        randomOperator = arc4random_uniform(UInt32(3))
        
        if randomOperator == 0 {
            nextOperator = "+"
        }
        else if randomOperator == 1 {
            nextOperator = "-"
        }
        else if randomOperator == 2 {
            nextOperator = "*"
        }
        else if randomOperator == 3 {
            nextOperator = "/"
        }
    }
    
    func generateNums() {
        randomNumber = arc4random_uniform(UInt32(9999))
        firstNum = Int(randomNumber)
        randomNumber = arc4random_uniform(UInt32(9999))
        secondNum = Int(randomNumber)
    }
    
    func generateDivisionEq() {
        randomNumber = arc4random_uniform(UInt32(9999))
        divisor = Int(randomNumber)
        randomNumber = arc4random_uniform(UInt32(9999))
        quotient = Int(randomNumber)
        dividend = divisor * quotient
    }
}