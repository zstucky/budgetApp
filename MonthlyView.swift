//
//  MonthlyView.swift
//  Budget
//
//  Created by Zach Stucky on 8/7/23.
//

import UIKit

class MonthlyView: UIViewController {

    
    @IBOutlet weak var monthlyTable: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var logsMonthly:[TransactionsMonthly]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthlyTable.delegate = self
        monthlyTable.dataSource = self
        fetchLogs()
    }
    
    //fetches all Transaction data
    func fetchLogs() {
        do {
            self.logsMonthly = try context.fetch(TransactionsMonthly.fetchRequest())
            DispatchQueue.main.async {
                self.monthlyTable.reloadData()
            }
        }
        catch {
            
        }
    }
    
    @IBAction func deleteAllLogs(_ sender: Any) {
        //loops until all logs are deleted
        while (logsMonthly!.count != 0) {
            let logToRemove = self.logsMonthly![0]
            self.context.delete(logToRemove)
            try! self.context.save()
            self.fetchLogs()
        }
    }
    
    //swipe to delete function
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let logToRemove = self.logsMonthly![indexPath.row]
            
            self.context.delete(logToRemove)
            
            do {
                try self.context.save()
            }
            catch {
            }
            self.fetchLogs( )
        }
        return UISwipeActionsConfiguration (actions: [action])
    }

}

extension MonthlyView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension MonthlyView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logsMonthly?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let Transactions = self.logsMonthly![indexPath.row]
        cell.textLabel?.text = "$\(Transactions.amount ?? "") \(Transactions.note ?? "no note")"
        switch Transactions.type {
        case "refund":
            cell.textLabel?.textColor = .cyan
        case "income":
            cell.textLabel?.textColor = .green
        case "GIWINTG":
            cell.textLabel?.textColor = .yellow
        case "expense":
            cell.textLabel?.textColor = .red
        default:
            cell.textLabel?.textColor = .gray
        }

        return cell
    }
}
