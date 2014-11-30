//
//  RootViewController.m
//  GooglePlusShareActivityExample
//
//  Created by Lysann Schlegel on 10/6/13.
//  Copyright (c) 2013 Lysann Schlegel. All rights reserved.
//

#import "RootViewController.h"

#import <GooglePlusShareActivity/GPPShareActivity.h>


@interface RootViewController ()

@property (strong, nonatomic) UIPopoverController* activityPopoverController;

@property (strong, nonatomic) UIImage* image;

@end


@implementation RootViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.image = [UIImage imageNamed:@"example.jpg"];
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
    // lay out
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
        [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
    ]];
    
    // navigation bar
    self.navigationItem.title = @"Google+ Sharing";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonClicked:)];
}

#pragma mark - Actions

- (NSArray*)activityItems
{
    // set up items to share, in this case some text and an image
    NSArray* activityItems = @[ @"Hello Google+!", self.image ];

    // URL sharing works as well. But you cannot share an image and a URL at the same time :(
    //NSArray* activityItems = @[ @"Hello Google+!", [NSURL URLWithString:@"https://github.com/lysannschlegel/GooglePlusShareActivity"] ];

    // If a file path URL is passed, it must point to an image. It is attached as if you used a UIImage directly.
    //NSArray* activityItems = @[ @"Hello Google+!", [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"jpg"] ];

    // You can also set up a GPPShareBuilder on your own. All other items will be ignored
    //id<GPPNativeShareBuilder> shareBuilder = (id<GPPNativeShareBuilder>)[GPPShare sharedInstance].nativeShareDialog;
    //[shareBuilder setPrefillText:@"Hello Google+!"];
    //[shareBuilder setURLToShare: [NSURL URLWithString:@"https://github.com/lysannschlegel/GooglePlusShareActivity"]];
    //NSArray* activityItems = @[ @"Does not appear", shareBuilder ];

    return activityItems;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0

// Use this much simpler code if you target only iOS 8 and above

- (void)shareButtonClicked:(UIBarButtonItem*)sender
{
    GPPShareActivity* gppShareActivity = [[GPPShareActivity alloc] init];

    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:self.activityItems applicationActivities:@[gppShareActivity]];
    activityViewController.popoverPresentationController.barButtonItem = sender;

    [self presentViewController:activityViewController animated:YES completion:NULL];
}

#else

// Use this code when you target iOS versions prior to iOS 8. Works on iOS 8 as well.

- (void)shareButtonClicked:(UIBarButtonItem*)sender
{
    // toggle activity popover on iPad. Show the modal share dialog on iPhone
    if (!self.activityPopoverController) {

        // set up and present activity view controller
        GPPShareActivity* gppShareActivity = [[GPPShareActivity alloc] init];
        UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:self.activityItems applicationActivities:@[gppShareActivity]];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // present in popup
            self.activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            gppShareActivity.activityPopoverViewController = self.activityPopoverController;
            [self.activityPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        } else {
            // present modally
            gppShareActivity.activitySuperViewController = self;
            [self presentViewController:activityViewController animated:YES completion:NULL];
        }
        
    } else {
        [self.activityPopoverController dismissPopoverAnimated:YES];
        self.activityPopoverController = nil;
    }
}

#endif

@end
