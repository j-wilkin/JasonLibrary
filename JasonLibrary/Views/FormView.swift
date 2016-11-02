//
//  FormView.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/8/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import UIKit

// Reusable Form protocol
protocol FormProtocol {
    func dictionaryForAPI() -> [String: AnyObject]
    func validateFields() -> Bool
    func formIsClean() -> Bool
    func formHasChanged(book: Book) -> Bool
    func formFields() -> [ValidationTextField]
    func autoFill(info: [NSObject:AnyObject])
}

protocol NextTextFieldProtocol {
    func jumpToNextField(currentField: ValidationTextField)
}

class FormView: UIView {
    
    @IBOutlet weak var titleField: ValidationTextField!
    @IBOutlet weak var authorField: ValidationTextField!
    @IBOutlet weak var publisherField: ValidationTextField!
    @IBOutlet weak var categoriesField: ValidationTextField!
    
    
    // Validation Errors for empty title and empty author
    enum ValidationErrors: ValidationErrorCase {
    
        case EmptyTitle
        case EmptyAuthor
        
        var message: String {
            switch self {
            case .EmptyTitle:
                return "Please provide a Title for the book."
            case .EmptyAuthor:
                return "Please provide an Author for the book."
            }
        }
        
        func isNonEmptyString(str: String) -> Bool {
            return !str.trim().isEmpty
        }
        
        var validationFunction: String -> Bool {
            switch self {
            case .EmptyTitle:
                return isNonEmptyString
            case .EmptyAuthor:
                return isNonEmptyString
            }
        }
    }
    
    func setup() {
        titleField.setup(
            "Title",
            APIName: "title",
            nextTextFieldDelegate: self)
        authorField.setup(
            "Author",
            APIName: "author",
            nextTextFieldDelegate: self)
        publisherField.setup(
            "Publisher",
            APIName: "publisher",
            nextTextFieldDelegate: self)
        categoriesField.setup(
            "Categories",
            APIName: "categories",
            nextTextFieldDelegate: self)
    }
    
    // Support prepopulating form fields for updating book
    func prepopulateFields(book: Book) {
        titleField.textField.text = book.title
        authorField.textField.text = book.author
        publisherField.textField.text = book.publisher
        categoriesField.textField.text = book.categoriesString()
    }
    
}

extension FormView: FormProtocol {

    func validateFields() -> Bool {
        let validTitle = titleField.validate(ValidationErrors.EmptyTitle)
        let validAuthor = authorField.validate(ValidationErrors.EmptyAuthor)
        return validTitle && validAuthor
    }
    
    func dictionaryForAPI() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        for field in formFields() {
            dict[field.key()] = field.value()
        }
        return dict
    }

    func formIsClean() -> Bool {
        return formFields().map { $0.isClean() }.reduce(true) { $0 && $1 }
    }
    
    func formFields() -> [ValidationTextField] {
        return [titleField, authorField, publisherField, categoriesField]
    }
    
    func formHasChanged(book: Book) -> Bool {
        let titleChanged = book.title != titleField.textField.text
        let authorChange = book.author != authorField.textField.text
        let publisherChanged = book.publisher != publisherField.textField.text
        let categoriesChanged = book.categoriesString() != categoriesField.textField.text
        return titleChanged || authorChange || publisherChanged || categoriesChanged
    }
    
    func autoFill(info: [NSObject : AnyObject]) {
        for field in formFields() {
            if let value = info[field.APIName] as? String {
                field.textField.text = value
            }
        }
    }
    
}

extension FormView: NextTextFieldProtocol {
    
    func jumpToNextField(currentField: ValidationTextField) {
        let fields = formFields()
        let indexOfNext = fields.indexOf(currentField)! + 1
        if indexOfNext >= fields.count {
            currentField.endEditing(true)
        } else {
            fields[indexOfNext].textField.becomeFirstResponder()
        }
    }
    
}
