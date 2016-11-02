//
//  DateExtensionTests.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/10/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import XCTest
@testable import JasonLibrary

class DateExtensionTests: XCTestCase {

    func test_apiToBook() {
        // Given
        let dateFormatter = NSDateFormatter()
        let apiDateStr = "2016-10-09 20:06:45"
        // When
        let bookDate = dateFormatter.convertDateStr(
            apiDateStr,
            inputFortmat: .API,
            outputFormat: .BookDetail
        )
        // Then
        XCTAssertEqual(bookDate, "October 9, 2016 8:06 PM")
    }
    
    func test_bookToAPI() {
        // Given
        let dateFormatter = NSDateFormatter()
        let bookDateStr = "October 11, 2016 3:09 AM"
        // When
        let bookDate = dateFormatter.convertDateStr(
            bookDateStr,
            inputFortmat: .BookDetail,
            outputFormat: .API
        )
        // Then
        XCTAssertEqual(bookDate, "2016-10-11 03:09:00")
    }
    
    
}
