// GPPShareActivity.h
//
// Copyright (c) 2013-2014 Lysann Schlegel (https://github.com/lysannschlegel)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

#import <GooglePlus/GooglePlus.h>

extern NSString *const GPPShareActivityType;


// An UIActivity that opens a share dialog for Google+.
// Item types accepted:
//   - NSString instances set the prefilled text of the share dialog. Any instance overrides
//     the previous one.
//   - UIImage instances are attached to the share dialog. Multiple instances can be attached.
//   - NSURL instances set the URL to be shared. Any instance overrides the previous one.
//   - Objects that conform to the GPPShareBuilder protocol override any other items, and
//     instead use only the item to create the share dialog. Any instance overrides the previous
//     one.
@interface GPPShareActivity : UIActivity

// Set one of these to dismiss the popover view controller (iPad) or presented view
// controller (iPhone) before initiating the Google+ sharing
@property (weak, nonatomic) UIPopoverController* activityPopoverViewController;
@property (weak, nonatomic) UIViewController* activitySuperViewController;

// Set to YES if the activity should be enabled even when there are no items it can share.
// The Google+ sharing form will then be empty, but can be filled by the user.
// Default is NO.
@property (assign, nonatomic) BOOL canShowEmptyForm;

@end
