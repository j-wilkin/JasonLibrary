//
//  BookDataStore.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/7/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation

class BookDataStore {
    
    // Singleton instance
    static let sharedInstance = BookDataStore()
    // Dictionary of book url -> book object
    private var library: [String: Book] = [:]
    // API
    let api = LibraryAPI()
    
    func refreshLibrary(completion: ([Book]?, NSError?) -> Void) {
        api.downloadLibrary { (books, error) in
            if error == nil {
                // Clear Library for new data
                self.library = [:]
                for book in books! {
                    self.library[book.url] = book
                }
            }
            completion(self.sortAlphabetically(books), error)
        }
    }
    
    func addBook(bookDict: [String: AnyObject], completion: (Book?, NSError?)->Void) {
        api.addBook(bookDict) { (book, error) in
            if error == nil {
                self.library[book!.url] = book!
                NSNotificationCenter.defaultCenter().postNotificationName(
                    Notifications.LibraryUpdated.rawValue,
                    object: nil
                )
            }
            completion(book, error)
        }
    }
    
    func updateBook(bookURL: String, updates: [String: AnyObject], completion: (Book?, NSError?)->Void) {
        api.updateBook(bookURL, updates: updates) { (book, error) in
            if error == nil {
                self.library[book!.url] = book!
                NSNotificationCenter.defaultCenter().postNotificationName(
                    Notifications.LibraryUpdated.rawValue,
                    object: nil
                )
            }
            completion(book, error)
        }
    }
    
    func deleteBook(bookURL: String, completion: NSError?->Void) {
        api.deleteBook(bookURL) { (error) in
            if error == nil {
                self.library.removeValueForKey(bookURL)
            }
            completion(error)
        }
    }
    
    
    func deleteAllBooks(completion: NSError?->Void) {
        api.deleteAllBooks { (error) in
            if error == nil {
                self.library = [:]
            }
            completion(error)
        }
    }
    
    func numberOfBooks() -> Int {
        return library.count
    }
    
    func getBooks() -> [Book] {
        return sortAlphabetically(Array(library.values))!
    }
    
    func sortAlphabetically(books: [Book]?) -> [Book]? {
        guard let books = books else {
            return nil
        }
        
        return books.sort {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .OrderedAscending
        }

    }
    
    func getBook(url: String) -> Book? {
        return library[url]
    }
    
}
