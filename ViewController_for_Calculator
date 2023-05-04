//
//  ViewController.swift
//  Calculator
//
//  Created by Miles Kominsky and Kate Carnevale on 1/31/23.
//

import UIKit

// Creates border option for all view objects
@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

class ViewController: UIViewController {
    
    // variables for the top and bottom of UI screen where calculations are stored
    @IBOutlet weak var calcWorkings: UILabel!
    @IBOutlet weak var calculatorResults: UILabel!
    
    var curr_calculation:String = ""
    
    //Clears the screen when app is loaded in
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
    }
    
    //clears the top view when called
    func clearAll(){
        
        curr_calculation = ""
        calcWorkings.text = ""
        calculatorResults.text = ""
    }

    @IBAction func allClearTap(_ sender: Any) {
        
        clearAll()

    }
    
    //backspace button
    @IBAction func backTap(_ sender: Any) {
        // only clears if there is something to clear
        if(!curr_calculation.isEmpty){
            curr_calculation.removeLast()
            calcWorkings.text = curr_calculation
        }
    }
    
    //when a button is pressed, the value is added to the top of view UI
    func addToCalculations(value: String){
        
        curr_calculation = curr_calculation + value
        calcWorkings.text = curr_calculation
        
    }
    
    // percent button
    @IBAction func percentTap(_ sender: Any) {
        
        addToCalculations(value: "%")
    }
    
    //divide button
    @IBAction func divideTap(_ sender: Any) {
        
        addToCalculations(value: "/")
    }
    
    // multiplication button
    @IBAction func timesTap(_ sender: Any) {
        
        addToCalculations(value: "*")
    }
    // addition button
    @IBAction func plusTap(_ sender: Any) {
        
        addToCalculations(value: "+")
    }
    
    //subtraction button
    @IBAction func minusTap(_ sender: Any) {
        addToCalculations(value: "-")
    }
    
    //decimal button
    @IBAction func decimalTap(_ sender: Any) {
        
        addToCalculations(value: ".")
    }
    
    //equals button
    @IBAction func equalTap(_ sender: Any) {
        
        if(validInput()){
            
            //correctly calculates the function of % button
            let checkIfPercent = curr_calculation.replacingOccurrences(of: "%", with: "*0.01")
            let expression = NSExpression(format: checkIfPercent)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            let resultString = formatResult(result: result)
            calculatorResults.text = resultString
        }
        else{
            //if the input isn't valid, we throw an error message
            let alert = UIAlertController(title: "Invalid Input", message: "You can't do that", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func validInput() -> Bool{
        
        //makes sure:
        // -there aren't two special characters in a row
        // -the first index isn't a special character
        // -the last index isn't a special character
        
        var count = 0
        
        var funtionCharIndex = [Int]()
        
        for char in curr_calculation
        {
            if(specialCharacter(char: char))
            {
                funtionCharIndex.append(count)
            }
            count += 1
        }
        
        var previous: Int = -1
        
        for index in funtionCharIndex {
            if(index == 0)
            {
                return false
            }
            if(index == curr_calculation.count - 1)
            {
                return false
            }
            
            if (previous != 1)
            {
                if(index - previous == 1)
                {
                    return false
                }
            }
            previous = index
        }
        return true
    }
    
    //returns if input is a special character
    func specialCharacter (char: Character) -> Bool
    {
        if(char == "*")
        {
            return true
        }
        if(char == "/")
        {
            return true
        }
        if(char == "+")
        {
            return true
        }
        if(char == "-")
        {
            return true
        }
        return false
    }
    
    //handles decimals and floats correctly rounding to two decimal places
    func formatResult(result: Double) -> String{
        
        if(result.truncatingRemainder(dividingBy: 1) == 0)
        {
            return String(format: "%.0f", result)
        }else{
            return String(format: "%.2f", result)
        }
    }
    
    // all remaining functions are buttons corresponding to the numbers
    @IBAction func zeroTap(_ sender: Any) {
        addToCalculations(value: "0")
    }
    
    @IBAction func oneTap(_ sender: Any) {
        addToCalculations(value: "1")
    }
    
    @IBAction func twoTap(_ sender: Any) {
        addToCalculations(value: "2")
    }
    
    @IBAction func threeTap(_ sender: Any) {
        addToCalculations(value: "3")
    }
    
    @IBAction func fourTap(_ sender: Any) {
        addToCalculations(value: "4")
    }
    
    @IBAction func fiveTap(_ sender: Any) {
        addToCalculations(value: "5")
    }
    
    @IBAction func sixTap(_ sender: Any) {
        addToCalculations(value: "6")
    }
    
    @IBAction func sevenTap(_ sender: Any) {
        addToCalculations(value: "7")
    }
    
    @IBAction func eightTap(_ sender: Any) {
        addToCalculations(value: "8")
    }
    
    @IBAction func nineTap(_ sender: Any) {
        addToCalculations(value: "9")
    }
}

