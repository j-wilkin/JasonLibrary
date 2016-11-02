//
//  ValidationTextField.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/7/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import UIKit

protocol APIRepresentable {
    func key() -> String
    func value() -> AnyObject
}

protocol FormFieldProtocol {
    func isClean() -> Bool
}

class ValidationTextField: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var errorLabelTopConstraint: NSLayoutConstraint!
    
    let hiddenConstraintConstant: CGFloat = -14
    let visibleConstraintConstant: CGFloat = 5
    
    var APIName = ""
    var nextTextFieldDelegate: NextTextFieldProtocol!
    
    enum ErrorStates: Int {
        case Visible
        case Hidden
        case Animating
    }
    var currentErrorState: ErrorStates = .Hidden
    
    func validate(errorCase: ValidationErrorCase) -> Bool {
        if textField.validate([errorCase.validationFunction]) {
            hideError()
            return true
        } else {
            showError(errorCase.message)
            return false
        }
    }
    
    
    func setup(placeholder: String, APIName: String, nextTextFieldDelegate: NextTextFieldProtocol) {
        textField.placeholder = placeholder
        errorLabel.alpha = 0
        errorLabelTopConstraint.constant = hiddenConstraintConstant
        currentErrorState = .Hidden
        self.APIName = APIName
        
        textField.delegate = self
        self.nextTextFieldDelegate = nextTextFieldDelegate
        
        errorLabel.layoutIfNeeded()
    }
    
    func showError(errorMessage: String) {
        if currentErrorState == .Hidden {
            // Set Visible error conditions
            currentErrorState = .Animating
            errorLabel.text = errorMessage
            errorLabelTopConstraint.constant = visibleConstraintConstant
            
            // Animate error fade in & drop down
            UIView.animateWithDuration(0.3, animations: { 
                self.errorLabel.alpha = 1
                self.layoutIfNeeded()
                }) { (complete) in
                if complete {
                    self.currentErrorState = .Visible
                }
            }
        }
    }
    
    func hideError() {
        if currentErrorState == .Visible {
            // Animate error fade out
            UIView.animateWithDuration(0.3, animations: {
                self.currentErrorState = .Animating
                self.errorLabel.alpha = 0
                }) { (complete) in
                    if complete {
                        self.errorLabelTopConstraint.constant = self.hiddenConstraintConstant
                        self.currentErrorState = .Hidden
                    }
                }
        }
    }
    
    
}

extension ValidationTextField: FormFieldProtocol {
    
    func isClean() -> Bool {
        return textField.text == ""
    }
    
}

extension ValidationTextField: APIRepresentable {
    
    func key() -> String {
        return APIName
    }
    
    func value() -> AnyObject {
        return textField.text!
    }
    
}

extension ValidationTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nextTextFieldDelegate.jumpToNextField(self)
        return false
    }
    
}

