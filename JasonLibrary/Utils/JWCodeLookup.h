//
//  JWCodeLookup.h
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/9/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLRBooks.h"

@interface JWCodeLookup : NSObject

@property (nonatomic, assign) BOOL isLooking;
@property (nonatomic, strong) GTLRBooksService *service;

- (void) getBookInfo:(NSString *)code completion:(void(^)(GTLRBooks_Volume* book))completion;

@end
