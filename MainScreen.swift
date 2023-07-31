//
//  ViewController.swift
//  Budget
//
//  Created by Zach Stucky on 7/26/23.
//

import UIKit

class MainScreen: UIViewController {
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var note: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        total.text = UserDefaults.standard.string(forKey: "BALANCE") ?? "0.00"
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
        //fetchLogs()
    }
    
    /*func fetchLogs() {
        do {
            print(try context.fetch(Transactions.fetchRequest()))
        }
        catch {
            
        }
    }*/

    @IBAction func addIncome(_ sender: Any) {
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
            
            /*let newTransaction = Transactions(context: context)
            newTransaction.amount = number.text
            newTransaction.note = note.text
            
            try! context.save()
            fetchLogs()*/
            
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
        }
        else {
            number.text = "error"
        }
    }
    
    @IBAction func resetTotal(_ sender: Any) {
        total.text = "0.00"
        total.textColor = .white
        UserDefaults.standard.set(total.text, forKey: "BALANCE")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        number.resignFirstResponder()
    }
}

