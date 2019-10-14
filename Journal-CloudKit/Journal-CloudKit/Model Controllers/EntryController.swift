//
//  EntryController.swift
//  Journal-CloudKit
//
//  Created by Jordan Lamb on 10/14/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    // Shared Instance
    static let shared = EntryController()
    
    // SOT
    var entries: [Entry] = []
    
    // Save
    func save(entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
        let newEntry = Entry(title: entry.title, bodyText: entry.bodyText)
        let entryRecord = CKRecord(entry: newEntry)
        CKContainer.default().privateCloudDatabase.save(entryRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
                let savedEntry = Entry(ckRecord: record)
                else { completion(false) ; return }
            self.entries.append(savedEntry)
            print("New Entry Saved Successfully")
            completion(true)
        }
    }
    // Create
    func addEntryWith(title: String, body: String, completion: @escaping (_ success: Bool) -> Void) {
        let newEntry = Entry(title: title, bodyText: body)
        save(entry: newEntry) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // Read
    func fetchEntries(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryStrings.RecordType, predicate: predicate)
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let records = foundRecords else {
                completion(false);
                return }
            let entries = records.compactMap( { Entry(ckRecord: $0) } )
            self.entries = entries
            print("Fetched Entries Successful")
            completion(true)
        }
    }
    
    // Update
    func deleteEntry() {
        
    }
    
    // Delete
}


