//
//  ViewController.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.12.12.
//  Copyright (c) 2012 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@class ReaderViewController;
@protocol ReaderViewDelegate
- (void) reader:(ReaderViewController *)reader didFinishWithHash:(NSString *)hash;
@end

@interface ReaderViewController : UIViewController <ZBarReaderViewDelegate>
@property (weak) id<ReaderViewDelegate> delegate;
@property (strong) IBOutlet ZBarReaderView *reader;
- (IBAction)closeForm:(id)sender;
@end
