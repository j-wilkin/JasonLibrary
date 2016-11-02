//
//  BookModelTests.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/7/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import XCTest
import SwiftyJSON
@testable import JasonLibrary

class BookModelTests: XCTestCase {
    
    var book1JSON: JSON? = nil
    var book2JSON: JSON? = nil
    
    override func setUp() {
        super.setUp()
        let bundle = NSBundle(forClass: self.dynamicType)
        
        let book1JSONPath = bundle.pathForResource("book1", ofType: "json")!
        let book1JSONData = NSData(contentsOfFile: book1JSONPath)!
        book1JSON = JSON(data: book1JSONData)
        
        let book2JSONPath = bundle.pathForResource("book2", ofType: "json")!
        let book2JSONData = NSData(contentsOfFile: book2JSONPath)!
        book2JSON = JSON(data: book2JSONData)
        
        
    }
    
    override func tearDown() {
        super.tearDown()
        book1JSON = nil
        book2JSON = nil
    }
    
    
    func test_BookModel1() {
        // Given
        let json = book1JSON!
        // When
        let book = Book(json: json)
        // Then
        XCTAssertEqual(book.title, json["title"].stringValue)
        XCTAssertEqual(book.author, json["author"].stringValue)
        XCTAssertEqual(book.publisher, json["publisher"].string)
        XCTAssertEqual(book.url, json["url"].stringValue)
        XCTAssertEqual(book.categoriesString(), json["categories"].stringValue)
        XCTAssertEqual(book.lastCheckedOut, json["lastCheckedOut"].string)
        XCTAssertEqual(book.lastCheckedOutBy, json["lastCheckedOutBy"].string)
    }
    
    func test_BookModel2() {
        // Given
        let json = book2JSON!
        // When
        let book = Book(json: json)
        // Then
        XCTAssertEqual(book.title, json["title"].stringValue)
        XCTAssertEqual(book.author, json["author"].stringValue)
        XCTAssertEqual(book.publisher, json["publisher"].string)
        XCTAssertEqual(book.url, json["url"].stringValue)
        XCTAssertEqual(book.categoriesString(), json["categories"].stringValue)
        XCTAssertEqual(book.lastCheckedOut, json["lastCheckedOut"].string)
        XCTAssertEqual(book.lastCheckedOutBy, json["lastCheckedOutBy"].string)
    }

    
    
}
