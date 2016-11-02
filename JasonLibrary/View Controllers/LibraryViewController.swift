//
//  LibraryViewController.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/6/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import UIKit

class LibraryViewController: UITableViewController {

    // Books to display in the tableView
    var visibleBooks: [Book] = []
    // Reusable cell identifier
    let cellIdentifier = "bookCell"
    // Navigation Bar Items
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    var addBookButton: UIBarButtonItem!
    var deleteAllButton: UIBarButtonItem!
    
    
// MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshTable()
        
        // Notification for when library is updated (called when new book is added)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(LibraryViewController.updateVisibleBooks),
            name: Notifications.LibraryUpdated.rawValue,
            object: nil
        )
        
        deleteAllButton = UIBarButtonItem(title: "Delete All", style: .Plain, target: self, action: #selector(LibraryViewController.deleteAllBooks))
        addBookButton = navigationItem.leftBarButtonItem
        addRefreshControl()
    }

    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LibraryViewController.refreshTable), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
    }
    
// MARK: TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleBooks.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            let book = visibleBooks[indexPath.row]
            cell.textLabel?.text = book.title
            cell.detailTextLabel?.text = book.author
            return cell
        }
        return UITableViewCell()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "bookDetailSegue" {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let bookDetailVC = segue.destinationViewController as! BookDetailViewController
            let book = visibleBooks[indexPath.row]
            bookDetailVC.book = book
        }
    }
    
// MARK: Updating Table Data
    
    func refreshTable() {
        BookDataStore.sharedInstance.refreshLibrary { (books, error) in
            self.refreshControl?.endRefreshing()

            if error == nil {
                self.visibleBooks = books!
                let sections = NSIndexSet(index: 0)
                self.tableView.reloadSections(sections, withRowAnimation: .Fade)
            } else {
                // Need to delay the call of the error alert view to wait for tableview refresh control
                // animation to finish. Presenting a UIAlertViewController at the same time as calling
                // .endRefreshing will cause tableview to get stuck in a pulled down state
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), {
                    self.presentErrorAlert(
                        "Unable To Refresh Library",
                        message: "Oops! Unable to refresh the library at this time. Try again."
                    )
                })
            }
        }
    }
    
    
    func updateVisibleBooks() {
        visibleBooks = BookDataStore.sharedInstance.getBooks()
        tableView.reloadData()
    }
    
    
// MARK: Editing
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let bookURL = visibleBooks[indexPath.row].url
            BookDataStore.sharedInstance.deleteBook(bookURL) { (error) in
                if error == nil {
                    self.visibleBooks.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                } else {
                    self.presentErrorAlert("Unable to Delete", message: "Oops! Unable to delete a book at this time. Try again.")
                }
            }
        }
    }
    
    @IBAction func didTapEditButton(sender: UIBarButtonItem) {
        toggleEditing()
    }
    
    func toggleEditing() {
        if tableView.editing {
            tableView.setEditing(false, animated: true)
            rightBarButton.title = "Edit"
            navigationItem.leftBarButtonItem = addBookButton
        } else {
            tableView.setEditing(true, animated: true)
            rightBarButton.title = "Done"
            navigationItem.leftBarButtonItem = deleteAllButton
        }
    }
    
    func deleteAllBooks() {
        
        let warningAlert = UIAlertController(
            title: "Delete All Books",
            message: "Are you sure you want to delete all books?",
            preferredStyle: .Alert
        )
        
        let confirmAction = UIAlertAction(title: "Delete All", style: .Destructive) { (action) in
            
            BookDataStore.sharedInstance.deleteAllBooks { error in
                if error == nil {
                    self.toggleEditing()
                    // Clear books
                    self.visibleBooks = []
                    let indexSet = NSIndexSet(index: 0)
                    self.tableView.reloadSections(indexSet, withRowAnimation: .Fade)
                } else {
                    self.presentErrorAlert("Unable to Delete All", message: "Oops! Unable to delete all books at this time. Try again.")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        warningAlert.addAction(confirmAction)
        warningAlert.addAction(cancelAction)
        self.presentViewController(warningAlert, animated: true, completion: nil)
    }
    
}
