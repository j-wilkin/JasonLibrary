//
//  PersistentStorage.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/21/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation

enum StorageError: ErrorType {
    case FailedToGetObject
}

protocol PersistentStorage {
    func saveObject(key: String, value: AnyObject)
    func getObject(key: String) throws -> AnyObject
}

struct StorageAccess: PersistentStorage {
    
    func saveObject(key: String, value: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
    }
    
    func getObject(key: String) throws -> AnyObject  {
        guard let object =  NSUserDefaults.standardUserDefaults().objectForKey(key) else {
            throw StorageError.FailedToGetObject
        }
        return object
    }
}
