//
//  EntryListTableViewController.swift
//  Journal-CloudKit
//
//  Created by Jordan Lamb on 10/14/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadEntryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entriesCell", for: indexPath)
        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timestamp.formatDate()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = EntryController.shared.entries[indexPath.row]
            guard let index = EntryController.shared.entries.firstIndex(of: entry) else { return }
            EntryController.shared.deleteEntry(entry: entry) { (success) in
                if success {
                    EntryController.shared.entries.remove(at: index)
                    
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEntryDetailVC" {
            guard let index = tableView.indexPathForSelectedRow else { return }
            guard let destinationVC = segue.destination as? EntryDetailViewController else { return }
            let objectToSend = EntryController.shared.entries[index.row]
            destinationVC.entry = objectToSend
        }
    }
    
    // MARK: - Load Data
    func loadEntryData() {
        EntryController.shared.fetchEntries { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
    // MARK: - Helper Functions
    func updateViews() {
        self.tableView.tableFooterView = UIView()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

}
