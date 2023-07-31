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
    
    @IBAction func resetLogs(_ sender: Any) {
        
        if (logs!.count > 0) {
            let logToRemove = self.logs![0]
            
            self.context.delete(logToRemove)
            
            try! self.context.save()
            
            self.fetchLogs()
        }
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
        cell.textLabel?.text = "\(Transactions.amount ?? "") \(Transactions.note ?? "no note")"
        return cell
    }
}
