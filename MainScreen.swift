//
//  ViewController.swift
//  Budget
//
//  Created by Zach Stucky on 7/26/23.
//

import WidgetKit
import UIKit

class MainScreen: UIViewController {
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var secondary: UILabel!
    @IBOutlet weak var specialSwitch: UISwitch!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads the amounts from last time the app was used
        total.text = UserDefaults.standard.string(forKey: "BALANCE") ?? "$0.00"
        secondary.text = UserDefaults.standard.string(forKey: "GIWINTG") ?? "$0.00"
        
        //sets the color for the main total
        if let color = total.text?.split(separator: "$").last {
            if let colorNum = Double(color) {
                if colorNum > 0
                {
                    total.textColor = .green
                }
                else if colorNum < 0
                {
                    total.textColor = .red
                }
                else
                {
                    total.textColor = .white
                }
            }
        }
        
        //sets the color for the secondary total
        if let colorSecondary = secondary.text?.split(separator: "$").last {
            if let colorNumSecondary = Double(colorSecondary) {
                if colorNumSecondary > 0
                {
                    secondary.textColor = .green
                }
                else if colorNumSecondary < 0
                {
                    secondary.textColor = .red
                }
                else
                {
                    secondary.textColor = .white
                }
            }
        }
    }
    
    
    //TO-DO: Address force unwrapping here
    @IBAction func addIncome(_ sender: Any) {
        //refund
        if specialSwitch.isOn {
            //gets the number value from the text string, adds the new value, and sets the color
            let oldString = total.text!.split(separator: "$").last
            let old = Double(oldString!)!
            if let cost = Double(number.text!) {
                let newTotal = old + cost
                total.text = "$\(String(format: "%.2f", newTotal))"
                UserDefaults.standard.set(total.text, forKey: "BALANCE")
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
                
                //creates a new log to be displayed in the LogView
                let newTransaction = Transactions(context: self.context)
                newTransaction.amount = number.text
                newTransaction.note = note.text
                newTransaction.type = "refund"
                
                try! self.context.save() //saves the log
                
                number.text = ""
                note.text = ""
                
                //for the widget
                let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
                //saves the main total
                guard let text = total.text, !text.isEmpty else {
                    return
                }
                userDefaultsShared?.setValue(text, forKey: "TEXT")

                WidgetCenter.shared.reloadAllTimelines() //upddates the widget data
            }
            else {
                //TO-DO: Make a real error message
                number.text = "error"
            }
        }
        //income
        else{
            //gets the number value from the text string, adds the new value, and sets the color
            let oldString = total.text!.split(separator: "$").last
            let old = Double(oldString!)!
            if let cost = Double(number.text!) {
                let newTotal = old + (0.75*cost)
                total.text = "$\(String(format: "%.2f", newTotal))"
                UserDefaults.standard.set(total.text, forKey: "BALANCE")
                
                //does the same thing for the secondary total
                let oldStringSecondary = secondary.text!.split(separator: "$").last
                let oldSecondary = Double(oldStringSecondary!)!
                let newTotalSecondary = oldSecondary + (0.15*cost)
                secondary.text = "$\(String(format: "%.2f", newTotalSecondary))"
                UserDefaults.standard.set(secondary.text, forKey: "GIWINTG")
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
                if newTotalSecondary > 0
                {
                    secondary.textColor = .green
                }
                else if newTotalSecondary < 0
                {
                    secondary.textColor = .red
                }
                else
                {
                    secondary.textColor = .white
                }
                
                //creates a new log to be displayed in the LogView
                let newTransaction = Transactions(context: self.context)
                newTransaction.amount = number.text
                newTransaction.note = note.text
                newTransaction.type = "income"
                
                try! self.context.save() //saves the log
                
                number.text = ""
                note.text = ""
                    
                //for the widget
                let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
                //saves the main total
                guard let text = total.text, !text.isEmpty else {
                    return
                }
                userDefaultsShared?.setValue(text, forKey: "TEXT")
                //saves the secondary total
                guard let textSecondary = secondary.text, !textSecondary.isEmpty else {
                    return
                }
                userDefaultsShared?.setValue(textSecondary, forKey: "SECONDARY")
                
                WidgetCenter.shared.reloadAllTimelines() //upddates the widget data
            }
            else {
                //TO-DO: Make a real error message
                number.text = "error"
            }
        }
    }
    
    //TO-DO: Address force unwrapping here
    @IBAction func subExpense(_ sender: Any) {
        //GIWINTG
        if specialSwitch.isOn {
            //gets the number value from the text string, subtracts the new value, and sets the color
            let oldString = secondary.text!.split(separator: "$").last
            let old = Double(oldString!)!
            if let cost = Double(number.text!) {
                let newTotal = old - cost
                secondary.text = "$\(String(format: "%.2f", newTotal))"
                UserDefaults.standard.set(secondary.text, forKey: "GIWINTG")
                if newTotal > 0
                {
                    secondary.textColor = .green
                }
                else if newTotal < 0
                {
                    secondary.textColor = .red
                }
                else
                {
                    secondary.textColor = .white
                }
                
                //creates a new log to be displayed in the LogView
                let newTransaction = Transactions(context: self.context)
                newTransaction.amount = number.text
                newTransaction.note = note.text
                newTransaction.type = "GIWINTG"
                
                try! self.context.save() //saves the log
                
                number.text = ""
                note.text = ""
                
                //for the widget
                let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
                //saves the secondary total
                guard let textSecondary = secondary.text, !textSecondary.isEmpty else {
                    return
                }
                userDefaultsShared?.setValue(textSecondary, forKey: "SECONDARY")
                
                WidgetCenter.shared.reloadAllTimelines() //upddates the widget data
            }
            else {
                //TO-DO: Make a real error message
                number.text = "error"
            }
        }
        
        //expense
        else {
            //gets the number value from the text string, subtracts the new value, and sets the color
            let oldString = total.text!.split(separator: "$").last
            let old = Double(oldString!)!
            if let cost = Double(number.text!) {
                let newTotal = old - cost
                total.text = "$\(String(format: "%.2f", newTotal))"
                UserDefaults.standard.set(total.text, forKey: "BALANCE")
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
                
                //creates a new log to be displayed in the LogView
                let newTransaction = Transactions(context: self.context)
                newTransaction.amount = number.text
                newTransaction.note = note.text
                newTransaction.type = "expense"
                
                try! self.context.save() //saves the log
                
                number.text = ""
                note.text = ""
                
                //for the widget
                let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
                //saves the main total
                guard let text = total.text, !text.isEmpty else {
                    return
                }
                userDefaultsShared?.setValue(text, forKey: "TEXT")

                WidgetCenter.shared.reloadAllTimelines() //upddates the widget data
            }
            else {
                //TO-DO: Make a real error message
                number.text = "error"
            }
        }
    }
    
    @IBAction func resetTotal(_ sender: Any) {
        //resets main total to defaults
        total.text = "$0.00"
        total.textColor = .white
        UserDefaults.standard.set(total.text, forKey: "BALANCE")
        
        //resets secondary to defaults
        secondary.text = "$0.00"
        secondary.textColor = .white
        UserDefaults.standard.set(secondary.text, forKey: "GIWINTG")
        
        //for the widget
        let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
        //saves the main total
        guard let text = total.text, !text.isEmpty else {
            return
        }
        userDefaultsShared?.setValue(text, forKey: "TEXT")
        //saves the secondary total
        guard let textSecondary = secondary.text, !textSecondary.isEmpty else {
            return
        }
        userDefaultsShared?.setValue(textSecondary, forKey: "SECONDARY")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //allows keyboard to go away from touching anywhere else on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        number.resignFirstResponder()
        note.resignFirstResponder()
    }
    
}
