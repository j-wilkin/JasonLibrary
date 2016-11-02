//
//  ViewControllerExtensionTests.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/10/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import JasonLibrary

class ViewControllerExtensionTests: XCTestCase {
    
    var viewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIViewController()
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
    }
    
    func testAlert_hasTitle() {
        // Given
        let title = "Test Title"
        let message = "This is a test message."
        // When
        viewController.presentErrorAlert(title, message: message)
        // Then
        XCTAssertTrue(viewController.presentedViewController is UIAlertController)
        XCTAssertEqual(viewController.presentedViewController?.title, title)
    }
    
    func testAlert_hasMessage() {
        // Given
        let title = "Test Title"
        let message = "This is a test message."
        // When
        viewController.presentErrorAlert(title, message: message)
        let alert = viewController.presentedViewController as! UIAlertController
        // Then
        XCTAssertEqual(alert.message, message)
    }
    
    func testAlert_hasOKAction() {
        // Given
        let title = "Test Title"
        let message = "This is a test message."
        // When
        viewController.presentErrorAlert(title, message: message)
        let alert = viewController.presentedViewController as! UIAlertController
        let action = alert.actions[0]
        // Then
        XCTAssertEqual(alert.actions.count, 1)
        XCTAssertEqual(action.title, "OK")
        XCTAssertEqual(action.style, UIAlertActionStyle.Cancel)
    }
    
    
}
