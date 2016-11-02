//
//  StringExtensionTests.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/10/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import XCTest
@testable import JasonLibrary

class StringExtensionTests: XCTestCase {
    
    func test_trimSpace1() {
        // Given
        let space = "    "
        let str = "Test"
        let whitespaceStr = space + str + space
        // When
        let trimmedStr = whitespaceStr.trim()
        // Then
        XCTAssertEqual(trimmedStr, str)
    }
    
    func test_trimSpace2() {
        // Given
        let space = "      "
        let str = "This is a longer test."
        let whitespaceStr = space + str + space
        // When
        let trimmedStr = whitespaceStr.trim()
        // Then
        XCTAssertEqual(trimmedStr, str)
    }
    
    func test_trimSpace3() {
        // Given
        let str = "Testing string with no leading/trailing whitespace."
        // When
        let trimmedStr = str.trim()
        // Then
        XCTAssertEqual(trimmedStr, str)
    }
    
    
}
