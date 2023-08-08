//
//  LogView.swift
//  Budget
//
//  Created by Zach Stucky on 7/31/23.
//

import UIKit

class LogView: UIViewController {
    
    @IBOutlet weak var logList: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var logs:[Transactions]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logList.delegate = self
        logList.dataSource = self
        fetchLogs()
    }
    
    //fetches all Transaction data
    func fetchLogs() {
        do {
            self.logs = try context.fetch(Transactions.fetchRequest())
            DispatchQueue.main.async {
                self.logList.reloadData()
            }
        }
        catch {
            
        }
    }
    
    //TO-DO: Add a warning pop-up for this
    @IBAction func deleteAllLogs(_ sender: Any) {
        //loops until all logs are deleted
        while (logs!.count != 0) {
            let logToRemove = self.logs![0]
            self.context.delete(logToRemove)
            try! self.context.save()
            self.fetchLogs()
        }
    }
    
    //swipe to delete function
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let logToRemove = self.logs![indexPath.row]
            
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


extension LogView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension LogView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let Transactions = self.logs![indexPath.row]
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
