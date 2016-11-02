//
//  LibraryAPI.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/6/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


struct LibraryAPI {
    
    func downloadLibrary(completion: ([Book]?, NSError?) -> Void) {
        
        Alamofire.request(LibraryRouter.GetAllBooks).validate().responseJSON { response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                let books = json.arrayValue.map({Book(json: $0)})
                completion(books, nil)
            case .Failure(let error):
                print("Error downloading books: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    
    func addBook(bookDict: [String: AnyObject], completion: (Book?, NSError?) -> Void) {
        let urlRequest = LibraryRouter.AddBook(bookDict)
        let request = Alamofire.request(
            urlRequest.method,
            urlRequest.URLRequest.URL!,
            parameters: bookDict,
            headers: ["Content-Type" : "application/x-www-form-urlencoded"]
        )
        
        request.validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let book = Book(json: JSON(data))
                    completion(book, nil)
                case .Failure(let error):
                    print("Error adding book: \(error.localizedDescription)")
                    completion(nil, error)
                }
        }
        
        
    }
    
    
    func updateBook(bookURL: String, updates: [String: AnyObject], completion: (Book?, NSError?) -> Void) {
        let urlRequest = LibraryRouter.UpdateBook(bookURL, updates)
        let request = Alamofire.request(
            urlRequest.method,
            urlRequest.URLRequest.URL!,
            parameters: updates,
            headers: ["Content-Type" : "application/x-www-form-urlencoded"]
        )
        
        request.validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let book = Book(json: JSON(data))
                    completion(book, nil)
                case .Failure(let error):
                    print("Error updating book: \(error.localizedDescription)")
                    completion(nil, error)
                }
        }
        
        
    }
    
    func deleteBook(bookURL: String, completion: NSError? -> Void) {
        Alamofire.request(LibraryRouter.DeleteBook(bookURL))
            .validate()
            .response { (_, _, _, error) in
                completion(error)
        }
    }
    
    func deleteAllBooks(completion: NSError? -> Void) {
        Alamofire.request(LibraryRouter.ClearBooks)
            .validate()
            .response { (_, _, _, error) in
                completion(error)
        }
    }
    
  
  
  
}
