//
//  ViewController.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.12.12.
//  Copyright (c) 2012 Marc Kirchmann. All rights reserved.
//

#import "ReaderViewController.h"
#import "MenuScannerConstants.h"

@implementation ReaderViewController
@synthesize reader;
@synthesize delegate;

- (void)viewDidLoad
{
    reader.readerDelegate = self;
    
    UIInterfaceOrientation current = [[UIApplication sharedApplication] statusBarOrientation];
    [reader willRotateToInterfaceOrientation:current duration:0.3];
}

- (void) viewWillAppear:(BOOL)animated
{
    [reader start];    
    [self.navigationItem setTitle:READER_TITLE];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [reader stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                duration:(NSTimeInterval)duration
{
    [reader willRotateToInterfaceOrientation:orientation duration:duration];
}

- (void) readerView: (ZBarReaderView *)view didReadSymbols:(ZBarSymbolSet *)syms fromImage:(UIImage *)img
{
    NSString *hash = @"";
    
    for(ZBarSymbol *sym in syms)
    {
        hash = sym.data;
        break;
    }
        
    if ([hash length] > 0 && delegate != nil) {
        [delegate reader:self didFinishWithHash:hash];
    }
}

- (IBAction)closeForm:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
