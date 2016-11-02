//
//  DateFormatterExtension.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/7/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation

enum DateStyles: String {
    case BookDetail = "MMMM d, y h:mm a"
    case API = "yyyy-MM-dd HH:mm:ss"
}

extension NSDateFormatter {
    
    func convertDateStr(inputDate: String,
                        inputFortmat: DateStyles,
                        outputFormat: DateStyles) -> String {
        
        self.dateFormat = inputFortmat.rawValue
        if let date = self.dateFromString(inputDate) {
            self.dateFormat = outputFormat.rawValue
            return self.stringFromDate(date)
        } else {
            // Error parsing inputDate
            return ""
        }
    }
    
    
    
}
