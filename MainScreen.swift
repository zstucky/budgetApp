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
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var secondary: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads the amounts from last time the app was used
        total.text = UserDefaults.standard.string(forKey: "BALANCE") ?? "$0.00"
        secondary.text = UserDefaults.standard.string(forKey: "GIWINTG") ?? "$0.00"

        //sets the color for the main total
        let color = total.text!.split(separator: "$").last
        let colorNum = Double(color!)!
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
        
        //sets the color for the secondary total
        let colorSecondary = secondary.text!.split(separator: "$").last
        let colorNumSecondary = Double(colorSecondary!)!
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
    
    @IBAction func addIncome(_ sender: Any) {
        
        //income
        if type.text == "income" {
            
            let oldString = total.text!.split(separator: "$").last
            let old = Double(oldString!)!
            if let cost = Double(number.text!) {
                let newTotal = old + (0.75*cost)
                total.text = "$\(String(format: "%.2f", newTotal))"
                UserDefaults.standard.set(total.text, forKey: "BALANCE")
                
                let oldStringSecondary = secondary.text!.split(separator: "$").last
                let oldSecondary = Double(oldStringSecondary!)!
                let newTotalSecondary = oldSecondary + (0.25*cost)
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
                
                number.text = ""
                note.text = ""
                type.text = ""
                    
                //for the widget
                let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
                guard let text = total.text, !text.isEmpty else {
                    return
                }
                userDefaultsShared?.setValue(text, forKey: "TEXT")
                WidgetCenter.shared.reloadAllTimelines()
            }
            else {
                number.text = "error"
            }
                
        }
            
        //refund
        else if type.text == "refund" {
            
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
                number.text = ""
                note.text = ""
                type.text = ""
                
                //for the widget
                let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
                guard let text = total.text, !text.isEmpty else {
                    return
                }
                userDefaultsShared?.setValue(text, forKey: "TEXT")
                WidgetCenter.shared.reloadAllTimelines()
            }
            else {
                number.text = "error"
            }
                
        }
            
        else if type.text == "others" {
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
                
                number.text = ""
                note.text = ""
                type.text = ""
                
                //for widget
                let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
                guard let text = total.text, !text.isEmpty else {
                    return
                }
                userDefaultsShared?.setValue(text, forKey: "TEXT")
                WidgetCenter.shared.reloadAllTimelines()
            }
            else {
                number.text = "error"
            }
        }
        
        //expense
        else {
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
                
                let newTransaction = Transactions(context: self.context)
                newTransaction.amount = number.text
                newTransaction.note = note.text
                
                try! self.context.save()
                
                number.text = ""
                note.text = ""
                type.text = ""
                
                let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
                guard let text = total.text, !text.isEmpty else {
                    return
                }
                userDefaultsShared?.setValue(text, forKey: "TEXT")
                WidgetCenter.shared.reloadAllTimelines()
            }
            else {
                number.text = "error"
            }
        }
    }
    
    @IBAction func resetTotal(_ sender: Any) {
        total.text = "$0.00"
        total.textColor = .white
        UserDefaults.standard.set(total.text, forKey: "BALANCE")
        
        secondary.text = "$0.00"
        secondary.textColor = .white
        UserDefaults.standard.set(secondary.text, forKey: "GIWINTG")
        
        //for the widget
        let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
        guard let text = total.text, !text.isEmpty else {
            return
        }
        userDefaultsShared?.setValue(text, forKey: "TEXT")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        number.resignFirstResponder()
        note.resignFirstResponder()
        type.resignFirstResponder()
    }
    
}
