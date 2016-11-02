//
//  StringExtension.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/7/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation

extension String {
    
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
}
