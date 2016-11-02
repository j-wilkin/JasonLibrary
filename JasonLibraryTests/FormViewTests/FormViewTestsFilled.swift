//
//  FormViewTestsFilled.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/12/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import XCTest
import SwiftyJSON
@testable import JasonLibrary

class FormViewTestsFilled: XCTestCase {
    
    var form: FormView!
    let testTitle = "Test title"
    let testAuthor = "Test author"
    let testPublisher = "Test publisher"
    let testCategories = "Test categories"
    
    override func setUp() {
        super.setUp()
        let bundle = NSBundle.mainBundle()
        form = bundle.loadNibNamed("FormView", owner: self, options: nil)![0] as! FormView
        form.setup()
        
        form.titleField.textField.text = testTitle
        form.authorField.textField.text = testAuthor
        form.publisherField.textField.text = testPublisher
        form.categoriesField.textField.text = testCategories
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_dictionaryForAPI() {
        let testDictionary: [String: String] = [
            "title": testTitle,
            "author": testAuthor,
            "publisher": testPublisher,
            "categories": testCategories
        ]
    
        let apiDictionary = form.dictionaryForAPI() as! [String: String]
        
        XCTAssertEqual(apiDictionary, testDictionary)
    }
    
    func test_validateFields() {
        let validated = form.validateFields()
        XCTAssertTrue(validated)
    }
    
    func test_formIsClean() {
        XCTAssertFalse(form.formIsClean())
    }
    
    func test_formHasChanged() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let bookJSONPath = bundle.pathForResource("book1", ofType: "json")!
        let bookJSONData = NSData(contentsOfFile: bookJSONPath)!
        let bookJSON = JSON(data: bookJSONData)
        let book = Book(json: bookJSON)
        
        let changed = form.formHasChanged(book)
        XCTAssertTrue(changed)
    }
    
    func test_formFields() {
        let fields = form.formFields()
        XCTAssertEqual(fields.count, 4)
        XCTAssertEqual(fields, [form.titleField, form.authorField, form.publisherField, form.categoriesField])
    }
    
    func test_autoFillSome() {
        let title = "New title"
        let author = "New author"
        let info = [
            "title": title,
            "author": author
        ]
        form.autoFill(info)
        XCTAssertEqual(form.titleField.textField.text, title)
        XCTAssertEqual(form.authorField.textField.text, author)
        XCTAssertEqual(form.publisherField.textField.text, testPublisher)
        XCTAssertEqual(form.categoriesField.textField.text, testCategories)
        
    }
    
    func test_autoFillAll() {
        let title = "New title"
        let author = "New author"
        let publisher = "New publisher"
        let categories = "New categories"
        let info = [
            "title": title,
            "author": author,
            "publisher": publisher,
            "categories": categories
        ]
        form.autoFill(info)
        XCTAssertEqual(form.titleField.textField.text, title)
        XCTAssertEqual(form.authorField.textField.text, author)
        XCTAssertEqual(form.publisherField.textField.text, publisher)
        XCTAssertEqual(form.categoriesField.textField.text, categories)
    }
    
    
    
    
    
    
}
