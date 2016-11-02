//
//  LibraryRouter.swift
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/6/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

import Foundation
import Alamofire

enum LibraryRouter: URLRequestConvertible {
    
    case GetAllBooks
    case GetBook(String)
    case AddBook([String:AnyObject])
    case UpdateBook(String, [String:AnyObject])
    case DeleteBook(String)
    case ClearBooks
    
    // Enter API URL here
    static let baseURLString = "http://example.com"
    
    var method: Alamofire.Method {
        switch self {
        case .GetAllBooks:
            return .GET
        case .GetBook:
            return .GET
        case .AddBook:
            return .POST
        case .UpdateBook:
            return .PUT
        case .DeleteBook:
            return .DELETE
        case .ClearBooks:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .GetAllBooks:
            return "/books/"
        case .GetBook(let bookURL):
            return "\(bookURL)"
        case .AddBook:
            return "/books/"
        case .UpdateBook(let bookURL, _):
            return "\(bookURL)"
        case .DeleteBook(let bookURL):
            return "\(bookURL)"
        case .ClearBooks:
            return "/clean/"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let url = NSURL(string: LibraryRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: (url.URLByAppendingPathComponent(path))!)
        mutableURLRequest.HTTPMethod = method.rawValue
        return mutableURLRequest
    }
    
    
}
