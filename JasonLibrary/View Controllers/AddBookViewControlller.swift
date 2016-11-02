//
//  AddBookViewControlller.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/7/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import UIKit

protocol ValidationErrorCase {
    var message: String { get }
    var validationFunction: String->Bool { get }
}


class AddBookViewController: UIViewController {


    @IBOutlet weak var form: FormView!
    
    // Bar button items
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addToLibraryButton: UIButton!
    
    // Success label
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var successConstraint: NSLayoutConstraint!

    // Scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form.setup()
    }
    
    
    @IBAction func didTapAddToLibraryButton(sender: UIButton) {
        if form.validateFields() {
            BookDataStore.sharedInstance.addBook(form.dictionaryForAPI(), completion: { (book, error) in
                if error != nil {
                    self.presentErrorAlert(
                        "Unable to Add",
                        message: "Oops! Unable to add a new book at this time. Try again."
                    )
                } else {
                    // User interaction is finished
                    self.view.userInteractionEnabled = false
                    // Animate success and return to library
                    self.animateSuccess()
                }
            })
        } else {
            // Show validation errors if scrolled down
            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    func animateSuccess() {
        successLabel.alpha = 0
        successLabel.hidden = false
        
        // Layout view before performing animation
        view.layoutIfNeeded()
        // Animating success label constraint
        successConstraint.constant = 0
        
        UIView.animateKeyframesWithDuration(1, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: {
            
            // Fade out submit button
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.15, animations: {
                self.addToLibraryButton.alpha = 0
            })
            
            // Animate in success label
            UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.3, animations: {
                self.successLabel.alpha = 1
                self.view.layoutIfNeeded()
            })
            
            }) { (complete) in
                if complete {
                    // Dismiss back to Library list
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
        }
    }

    
    @IBAction func didTapCancelButton(sender: AnyObject) {
        if form.formIsClean() {
            // Safe to close the form
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            // Form contains user input; need to confirm with user before closing
            presentConfirmationAlert()
        }
    }
    
    
    func presentConfirmationAlert() {
        let alert = UIAlertController(
            title: "Unsaved Changes",
            message: "Are you sure you want to leave this screen?",
            preferredStyle: .Alert
        )
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "barcodeLookupSegue" {
            let barcodeVC = segue.destinationViewController as! JWBarcodeScannerViewController
            barcodeVC.delegate = self
        }
    }

    
}


extension AddBookViewController: BarcodeAutofillDelegate {
    
    // Fills form with book data from Barcode View
    func didGetBookInfo(bookInfo: [NSObject : AnyObject]!) {
        form.autoFill(bookInfo)
    }
    
}
