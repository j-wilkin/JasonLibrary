//
//  UpdateBookViewController.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/9/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import UIKit

class UpdateBookViewController: AddBookViewController {
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form.prepopulateFields(book)
    }
    
    override func didTapAddToLibraryButton(sender: UIButton) {
        if form.validateFields() {
            BookDataStore.sharedInstance.updateBook(book.url, updates: form.dictionaryForAPI(), completion: { (book, error) in
                if error != nil {
                    self.presentErrorAlert(
                        "Unable to Update",
                        message: "Oops! Unable to update the at this time. Try again."
                    )
                } else {
                    // Update book detail view with new data
                    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.BookUpdated.rawValue, object: book!.url)
                    // User interaction is finished
                    self.view.userInteractionEnabled = false
                    // Animate success and dismiss back to detail view
                    self.animateSuccess()
                }
            })
        } else {
            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    override func didTapCancelButton(sender: AnyObject) {
        if form.formHasChanged(book) {
            // Form has changed; need to confirm with user before closing
            presentConfirmationAlert()
        } else {
            // Safe to close the form
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
}
