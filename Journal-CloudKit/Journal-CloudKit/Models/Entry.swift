//
//  Entry.swift
//  Journal-CloudKit
//
//  Created by Jordan Lamb on 10/14/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation
import CloudKit

struct EntryStrings{
    static let TitleKey = "title"
    static let BodyKey = "body"
    static let TimestampKey = "timestamp"
    static let RecordType = "Entry"
}

class Entry {
    let title: String
    let bodyText: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init (title: String, bodyText: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryStrings.TitleKey] as? String,
            let bodyText = ckRecord[EntryStrings.BodyKey] as? String,
            let timestamp = ckRecord[EntryStrings.TimestampKey] as? Date
            else { return nil }
        
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryStrings.RecordType , recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: EntryStrings.TitleKey)
        self.setValue(entry.bodyText, forKey: EntryStrings.BodyKey)
        self.setValue(entry.timestamp, forKey: EntryStrings.TimestampKey)
    }
}
