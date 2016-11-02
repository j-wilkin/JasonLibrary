//
//  FormViewTests.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/12/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import XCTest
import SwiftyJSON
@testable import JasonLibrary

class FormViewTestsEmpty: XCTestCase {
    
    var form: FormView!
    
    override func setUp() {
        super.setUp()
        let bundle = NSBundle.mainBundle()
        form = bundle.loadNibNamed("FormView", owner: self, options: nil)![0] as! FormView
        form.setup()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_emptyDictionaryForAPI() {
        let emptyDictionary: [String: String] = [
            "title": "",
            "author": "",
            "publisher": "",
            "categories": ""
        ]
        let apiDictionary = form.dictionaryForAPI() as! [String: String]
        
        XCTAssertEqual(apiDictionary, emptyDictionary)
    }
    
    func test_validateFields() {
        let failingValidation = form.validateFields()
        XCTAssertFalse(failingValidation)
    }
    
    func test_formIsClean() {
        XCTAssertTrue(form.formIsClean())
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
        let title = "My title"
        let author = "My author"
        let info = [
            "title": title,
            "author": author
        ]
        form.autoFill(info)
        XCTAssertEqual(form.titleField.textField.text, title)
        XCTAssertEqual(form.authorField.textField.text, author)
    }
    
    func test_autoFillAll() {
        let title = "My title"
        let author = "My author"
        let publisher = "My publisher"
        let categories = "My categories"
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
