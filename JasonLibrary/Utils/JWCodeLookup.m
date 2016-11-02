//
//  JWCodeLookup.m
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/9/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

#import "JWCodeLookup.h"


@implementation JWCodeLookup


- (instancetype)init
{
    self = [super init];
    if (self) {
        _service = [[GTLRBooksService alloc] init];
        _service.retryEnabled = YES;
        _isLooking = NO;
    }
    return self;
}

- (void) getBookInfo:(NSString *)code completion:(void(^)(GTLRBooks_Volume* book))completion
{
    
    _isLooking = YES;
    NSString *queryStr = [NSString stringWithFormat:@"isbn:%@", code];
    GTLRBooksQuery *query = [GTLRBooksQuery_VolumesList queryWithQ:queryStr];
    
    [_service executeQuery:query completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
        
        if (callbackError != nil) {
            // Book not found
            completion(nil);
        } else {
            GTLRBooks_Volumes *volumes = object;
            GTLRBooks_Volume *firstBook = [volumes.items firstObject];
            completion(firstBook);
            _isLooking = NO;
        }
    }];
    
}


@end
