//
//  JWBarcodeScannerViewController.h
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/9/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate for providing book info from BarcodeScanner
@protocol BarcodeAutofillDelegate;

@interface JWBarcodeScannerViewController : UIViewController

@property (nonatomic, weak) id<BarcodeAutofillDelegate> delegate;

@end

@protocol BarcodeAutofillDelegate <NSObject>
@required
-(void) didGetBookInfo:(NSDictionary *)bookInfo;

@end
