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
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // SOT
    var entries: [Entry] = []
    
    // Save
    func save(entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
        let newEntry = Entry(title: entry.title, bodyText: entry.bodyText)
        let entryRecord = CKRecord(entry: newEntry)
        privateDB.save(entryRecord) { (record, error) in
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
        privateDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
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
    func updateEntry(entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
        let recordToUpdate = CKRecord(entry: entry)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return }
            
            guard recordToUpdate == records?.first else {
            print("Unexpected record was updated")
            completion(false)
                return }
            print("Updated \(recordToUpdate.recordID) successfully in CloudKit")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    // Delete
    func deleteEntry(entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [entry.ckRecordID])
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, recordsID, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard entry.ckRecordID == recordsID?.first else {
                completion(false)
                print("Unexpected recordID was deleted")
                return }
            
            print("Successfully deleted Entry")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    func slowDeleteEntry(entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
        privateDB.delete(withRecordID: entry.ckRecordID) { (_, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
        }
    }
}



