//
//  BookDetailViewController.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/7/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import UIKit

class BookDetailViewController: UIViewController {
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var checkedOutLabel: UILabel!
    
    // Book model
    var book: Book!
    
    // NSUserDefaults
    let storage = StorageAccess()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        addShareButton()
        
        // Notification to update labels with updated book data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BookDetailViewController.updateBook(_:)), name: Notifications.BookUpdated.rawValue, object: nil)
    }
    
    func setLabels() {
        titleLabel.text = book.title
        authorLabel.text = book.author
        publisherLabel.text = book.publisher
        
        if !book.categories.isEmpty {
            tagsLabel.text = (book.categoriesString())
        } else {
            tagsLabel.hidden = true
        }
        
        setCheckedOutLabel(animated: false)
    }
    
    func setCheckedOutLabel(animated animated: Bool) {
        var checkedOutText = "N/A"
        
        // Make sure we have checkout data
        if let checkedOutTime = book.lastCheckedOut,
            let checkedOutPerson = book.lastCheckedOutBy {
            // Convert and Display checked out time, person
            let dateFormatter = NSDateFormatter()
            let displayDate = dateFormatter.convertDateStr(
                checkedOutTime,
                inputFortmat: .API,
                outputFormat: .BookDetail
            )
            checkedOutText = "\(checkedOutPerson) @ \(displayDate)"
        }
        
        // Animate checkout
        if animated {
            UIView.transitionWithView(checkedOutLabel, duration: 0.4, options: .TransitionFlipFromBottom, animations: {
                self.checkedOutLabel.text = checkedOutText
                }, completion: nil)
        } else {
            checkedOutLabel.text = checkedOutText
        }
    }
    
    func updateBook(sender: AnyObject) {
        guard let bookURL = sender.object as? String where book.url == bookURL else {
            return
        }
        // Get updated book data from DataStore
        self.book = BookDataStore.sharedInstance.getBook(bookURL)!
        setLabels()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "updateBookSegue" {
            let updateBookVC = segue.destinationViewController as! UpdateBookViewController
            updateBookVC.book = book
        }
    }
    
    
// MARK: Share
    
    func addShareButton() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(BookDetailViewController.share))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    func share() {
        let activityController = UIActivityViewController(activityItems: [book.shareText()], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    
// MARK: Checkout
    
    
    @IBAction func didTapCheckoutButton(sender: UIButton) {
        promptForName()
    }
    

    func getSavedName() -> String? {
        do {
            if let name = try storage.getObject(UserDefaults.SavedName.rawValue) as? String {
                return name
            }
        }
        catch {
            return nil
        }
        
        return nil
    }
    

    func saveName(name: String) {
        storage.saveObject(UserDefaults.SavedName.rawValue, value: name)
    }
    
    func promptForName() {
        var nameTextField: UITextField?
        let namePrompt = UIAlertController(title: "Enter Name", message: "Please enter your name for the checkout log.", preferredStyle: UIAlertControllerStyle.Alert)
        
        namePrompt.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
            nameTextField = textField
            if let name = self.getSavedName() {
                textField.text = name
            }
        }
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // Ensure we have a non-empty/non-whitespace string
            if let name = nameTextField?.text?.trim() where name != "" {
                self.performCheckout(name)
                self.saveName(name)
            } else {
                // Ask again if no name is entered
                self.promptForName()
            }
        }
        let cancelAction = UIAlertAction(title: "Canel", style: .Cancel, handler: nil)
        namePrompt.addAction(defaultAction)
        namePrompt.addAction(cancelAction)
        self.presentViewController(namePrompt, animated: true, completion: nil)
        
    }
    
    func performCheckout(name: String) {
        let checkoutUpdate = ["lastCheckedOutBy": name]
        BookDataStore.sharedInstance.updateBook(book.url, updates: checkoutUpdate) { (book, error) in
            if error == nil {
                self.book = book
                self.setCheckedOutLabel(animated: true)
            } else {
                self.presentErrorAlert("Unable to Checkout", message: "Oops! Unable to checkout the book at this time. Try again.")
            }
        }
    }
    
    
    
    
    
}

