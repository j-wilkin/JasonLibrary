//
//  ViewControllerExtension.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/8/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Presents a simple UIAlertController with custom title and message
    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert
        )
        
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
