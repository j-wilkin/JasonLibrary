//
//  TextFieldExtension.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/7/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    // http://blog.prolificinteractive.com/2016/09/08/a-functional-approach-to-uitextfield-validation/
    
    func validate(functions: [(String -> Bool)]) -> Bool {
        return functions.map { f in f((self.text ?? "").trim()) }.reduce(true) { $0 && $1 }
    }
    
}
