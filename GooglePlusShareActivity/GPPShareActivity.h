//
//  GPPShareActivity.h
//  GooglePlusShareActivity
//
//  Created by Lysann Schlegel on 10/6/13.
//  Copyright (c) 2013 Lysann Schlegel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GooglePlus/GooglePlus.h>


// An UIActivity that opens a share dialog for Google+.
// Item types accepted:
//   - NSString instances set the prefilled text of the share dialog. Any instance overrides
//     the previous one.
//   - UIImage instances are attached to the share dialog. Multiple instances can be attached.
//   - NSURL instances set the URL to be shared. Any instance overrides the previous one.
//   - Objects that conform to the GPPShareBuilder protocol override any other items, and
//     instead use only the item to create the share dialog. Any instance overrides the previous
//     one.
@interface GPPShareActivity : UIActivity <GPPSignInDelegate, GPPShareDelegate>

// Set one of these to dismiss the popover view controller (iPad) or presented view
// controller (iPhone) before initiating the Google+ sharing
@property (weak, nonatomic) UIPopoverController* activityPopoverViewController;
@property (weak, nonatomic) UIViewController* activitySuperViewController;

// Set to YES if the activity should be enabled even when there are no items it can share.
// The Google+ sharing form will then be empty, but can be filled by the user.
// Default is YES.
@property (assign, nonatomic) BOOL canShowEmptyForm;

@end
