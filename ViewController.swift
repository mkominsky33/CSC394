//
//  ViewController.swift
//  Calculator
//
//  Created by Miles Kominsky on 1/31/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var calcWorkings: UILabel!
    @IBOutlet weak var calculatorResults: UILabel!
    
    var curr_calculation:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
        // Do any additional setup after loading the view.
    }
    
    func clearAll(){
        
        curr_calculation = ""
        calcWorkings.text = ""
        calculatorResults.text = ""
    }

    @IBAction func allClearTap(_ sender: Any) {
        
        clearAll()

    }
    
    @IBAction func backTap(_ sender: Any) {
        if(!curr_calculation.isEmpty){
            curr_calculation.removeLast()
            calcWorkings.text = curr_calculation
        }
    }
    
    func addToCalculations(value: String){
        
        curr_calculation = curr_calculation + value
        calcWorkings.text = curr_calculation
        
    }
    
    @IBAction func percentTap(_ sender: Any) {
        
        addToCalculations(value: "%")
    }
    
    @IBAction func divideTap(_ sender: Any) {
        
        addToCalculations(value: "/")
    }
    
    
    @IBAction func timesTap(_ sender: Any) {
        
        addToCalculations(value: "*")
    }

    @IBAction func plusTap(_ sender: Any) {
        
        addToCalculations(value: "+")
    }
    
    @IBAction func decimalTap(_ sender: Any) {
        
        addToCalculations(value: ".")
    }
    
    @IBAction func equalTap(_ sender: Any) {
        
        //let checkIfPercent = workings.replacingOccurrences(of: "%", with: *0.01)
        let expression = NSExpression(format: curr_calculation)
        let result = expression.expressionValue(with: nil, context: nil) as! Double
        let resultString = formatResult(result: result)
        calculatorResults.text = resultString
        
    }
    
    func formatResult(result: Double) -> String{
        
        if(result.truncatingRemainder(dividingBy: 1) == 0)
        {
            return String(format: "%.0f", result)
        }else{
            return String(format: "%.2f", result)
        }
    }
    
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
    @IBAction func minusTap(_ sender: Any) {
        addToCalculations(value: "-")
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

