//
//  ViewController.swift
//  Budget
//
//  Created by Zach Stucky on 7/26/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var number: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        total.text = "$0.00"
    }

    @IBAction func addIncome(_ sender: Any) {
        let oldString = total.text!.split(separator: "$").last
        let old = Double(oldString!)!
        if let cost = Double(number.text!) {
            let newTotal = old + cost
            total.text = "$\(String(format: "%.2f", newTotal))"
            if newTotal > 0
            {
                total.textColor = .green
            }
            else if newTotal < 0
            {
                total.textColor = .red
            }
            else
            {
                total.textColor = .white
            }
            number.text = ""
        }
        else {
            number.text = "error"
        }
    }
    
    @IBAction func subExpense(_ sender: Any) {
        let oldString = total.text!.split(separator: "$").last
        let old = Double(oldString!)!
        if let cost = Double(number.text!) {
            let newTotal = old - cost
            total.text = "$\(String(format: "%.2f", newTotal))"
            if newTotal > 0
            {
                total.textColor = .green
            }
            else if newTotal < 0
            {
                total.textColor = .red
            }
            else
            {
                total.textColor = .white
            }
            number.text = ""
        }
        else {
            number.text = "error"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        number.resignFirstResponder()
    }
}

