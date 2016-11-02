//
//  Book.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/6/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Shareable {
    func shareText() -> String
}

struct Book {
    
    let author, title, url, publisher: String
    let categories: [String]
    var lastCheckedOut, lastCheckedOutBy: String?
        
    
    init(json: JSON) {
        author = json["author"].stringValue
        title = json["title"].stringValue
        url = json["url"].stringValue
        publisher = json["publisher"].stringValue
        
        let categoriesString = json["categories"].stringValue
        categories = categoriesString.componentsSeparatedByString(",").map({ $0.trim() })

        lastCheckedOut = json["lastCheckedOut"].string
        lastCheckedOutBy = json["lastCheckedOutBy"].string
    }
    
    func categoriesString() -> String {
        return categories.joinWithSeparator(", ")
    }
    
}

extension Book: Shareable {
    
    func shareText() -> String {
        return "I'm reading \(title) by \(author)!"
    }
}
