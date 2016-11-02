//
//  LibraryRouterTests.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/6/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import XCTest
import Alamofire
@testable import JasonLibrary

class LibraryRouterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_getAllBooksURL() {
        // Given
        let urlRequest = LibraryRouter.GetAllBooks
        // When
        let method = urlRequest.method
        let urlString = urlRequest.URLRequest.URLString
        // Then
        XCTAssertEqual(method, Alamofire.Method.GET)
        XCTAssertEqual(urlString, LibraryRouter.baseURLString + "/books/")
        
    }
    
    func test_getBookURL() {
        // Given
        let bookURL = "/books/1/"
        let urlRequest = LibraryRouter.GetBook(bookURL)
        // When
        let method = urlRequest.method
        let urlString = urlRequest.URLRequest.URLString
        // Then
        XCTAssertEqual(method, Alamofire.Method.GET)
        XCTAssertEqual(urlString, LibraryRouter.baseURLString + bookURL)
        
    }
    
    func test_addBookURL() {
        // Given
        let parameters = [
            "author": "Ash Maurya",
            "categories": "process",
            "title": "Running Lean",
            "publisher": "O'REILLY",
        ]
        let urlRequest = LibraryRouter.AddBook(parameters)
        // When
        let method = urlRequest.method
        let urlString = urlRequest.URLRequest.URLString
        // Then
        XCTAssertEqual(method, Alamofire.Method.POST)
        XCTAssertEqual(urlString, LibraryRouter.baseURLString + "/books/")
        
        // need to test url parameters
    }
    
    func test_updateBookURL() {
        // Given
        let bookURL = "/books/1/"
        let parameters = ["lastCheckedOutBy": "Pablo"]
        let urlRequest = LibraryRouter.UpdateBook(bookURL, parameters)
        // When
        let method = urlRequest.method
        let urlString = urlRequest.URLRequest.URLString
        // Then
        XCTAssertEqual(method, Alamofire.Method.PUT)
        XCTAssertEqual(urlString, LibraryRouter.baseURLString + bookURL)
        
        // need to test url parameters
    }
    
    func test_deleteBookURL() {
        // Given
        let bookURL = "/books/1/"
        let urlRequest = LibraryRouter.DeleteBook(bookURL)
        // When
        let method = urlRequest.method
        let urlString = urlRequest.URLRequest.URLString
        // Then
        XCTAssertEqual(method, Alamofire.Method.DELETE)
        XCTAssertEqual(urlString, LibraryRouter.baseURLString + bookURL)
        
    }
    
    func test_clearBooksURL() {
        // Given
        let urlRequest = LibraryRouter.ClearBooks
        // When
        let method = urlRequest.method
        let urlString = urlRequest.URLRequest.URLString
        // Then
        XCTAssertEqual(method, Alamofire.Method.DELETE)
        XCTAssertEqual(urlString, LibraryRouter.baseURLString + "/clean/")
        
    }
    

    

    
}
