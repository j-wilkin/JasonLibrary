//
//  JWBarcodeScannerViewController.m
//  JasonLibrary
//
//  Created by Jason Wilkin on 10/9/16.
//  Copyright © 2016 Jason Wilkin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "JWBarcodeScannerViewController.h"
#import "JWCodeLookup.h"
#import "JasonLibrary-Swift.h"

@interface JWBarcodeScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    // Camera
    AVCaptureSession *captureSession;
    AVCaptureDevice *captureDevice;
    AVCaptureDeviceInput *deviceInput;
    AVCaptureMetadataOutput *metadataOutput;
    AVCaptureVideoPreviewLayer *previewLayer;
    
    // Google Books barcode lookup helper
    JWCodeLookup *codeLookup;
    
    // Views
    UIView *barcodeHighlightView;
    __weak IBOutlet UILabel *instructionLabel;
    __weak IBOutlet UIView *previewView;
    
}
@end

@implementation JWBarcodeScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBarcodeHighlightView];
    [self setupCaptureSession];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Initialize google books helper
    codeLookup = [[JWCodeLookup alloc] init];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // Reset the code lookup; Query needs to be refreshed
    codeLookup = nil;
}


- (void)setupBarcodeHighlightView
{
    barcodeHighlightView = [[UIView alloc] init];
    barcodeHighlightView.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin     |
        UIViewAutoresizingFlexibleBottomMargin  |
        UIViewAutoresizingFlexibleLeftMargin    |
        UIViewAutoresizingFlexibleRightMargin;
    
    barcodeHighlightView.layer.borderColor = [UIColor greenColor].CGColor;
    barcodeHighlightView.layer.borderWidth = 2;
    [self.view addSubview:barcodeHighlightView];
    [self.view bringSubviewToFront:barcodeHighlightView];
}


- (void)setupCaptureSession
{
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    captureSession = [[AVCaptureSession alloc] init];
    
    NSError *error;
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (deviceInput) {
        [captureSession addInput:deviceInput];
        [self setupPreviewLayer:^{
            [captureSession startRunning];
            [self addMetaDataCaptureOutToSession];
        }];
        
    } else {
        NSLog(@"Error establishing capture session: %@", error.localizedDescription);
        [self presentErrorAlert:@"Unable to Start Camera" message:@"Unable to start camera. Try again."];
    }
}

- (void) setupPreviewLayer:(void (^)(void))completion
{
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    if (previewLayer) {
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        // Handling starting from landscape mode (only portrait is supported)
        if (self.view.bounds.size.width > self.view.bounds.size.height) {
            previewLayer.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
        } else {
            previewLayer.frame = self.view.bounds;
        }
        [previewView.layer addSublayer:previewLayer];
        completion();
    } else {
        [self presentErrorAlert:@"Unable to Start Camera" message:@"Unable to start camera. Try again."];
    }
}

- (void) addMetaDataCaptureOutToSession
{
    metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:metadataOutput];
    metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes;
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
}
         
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightRect = CGRectZero;
    if (!codeLookup.isLooking) {
        AVMetadataMachineReadableCodeObject *barcodeObject;
        NSString *detectionString = nil;
        // ISB barcode types supported
        NSArray *barcodeTypes = @[
                                  AVMetadataObjectTypeEAN8Code,
                                  AVMetadataObjectTypeEAN13Code
                                  ];
        
        for (AVMetadataObject *metadata in metadataObjects) {
            for (NSString *type in barcodeTypes) {
                if ([metadata.type isEqualToString:type]) {
                    barcodeObject = (AVMetadataMachineReadableCodeObject *)[previewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *) metadata];
                    highlightRect = barcodeObject.bounds;
                    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                    break;
                }
            }
            
            if (detectionString != nil) {
                if (!codeLookup.isLooking) {
                    instructionLabel.text = @"Looking up ISBN...";
                    [self lookupCode:detectionString];
                }
                break;
            } else {
                instructionLabel.text = @"No code found.";
            }
        }
        
    }
    barcodeHighlightView.frame = highlightRect;
    
}

- (void) lookupCode:(NSString *)code
{
    [codeLookup getBookInfo:code completion:^(GTLRBooks_Volume *book) {
        
        if (book == nil) {
            instructionLabel.text = @"Unable to find book.";
        } else {
            NSDictionary *bookInfo = @{
                                       @"title": book.volumeInfo.title,
                                       @"author": [book.volumeInfo.authors componentsJoinedByString:@", "],
                                       @"publisher": book.volumeInfo.publisher,
                                       @"categories": [book.volumeInfo.categories componentsJoinedByString:@", "]
                                       };
            if (self.delegate != nil) {
                [_delegate didGetBookInfo:bookInfo];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}


- (IBAction)didTapCancelButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL) shouldAutorotate {
    return NO;
}


@end
