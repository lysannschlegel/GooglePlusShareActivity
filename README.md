[![CocoaPods Version](http://img.shields.io/cocoapods/v/GooglePlusShareActivity.svg?style=flat)](http://cocoapods.org/?q=GooglePlusShareActivity) [![License](http://img.shields.io/cocoapods/l/GooglePlusShareActivity.svg?style=flat)](https://github.com/lysannschlegel/GooglePlusShareActivity/blob/master/LICENSE)

This library provides a UIActivity subclass for Google+ sharing. It uses the native share builder API from the official Google+ iOS SDK for sharing, and the GPPSignIn API for signing in.

## Screenshots

<img src="https://github.com/lysannschlegel/GooglePlusShareActivity/wiki/screenshots/UIActivityViewController.png" alt="UIActivityViewController with GooglePlusShareActivity" width="200px"/> &nbsp;
<img src="https://github.com/lysannschlegel/GooglePlusShareActivity/wiki/screenshots/GPPShareBuilder_text.png" alt="GPPShareBuilder" width="200px"/>

## Setup & Usage

Below are detailed instructions for integrating and using the library in your iOS app.
There are also example projects for Swift and Objective-C in the `Examples` directory.

### Installation

Installation through [CocoaPods](http://cocoapods.org/) is recommended:
``` ruby
pod 'GooglePlusShareActivity'
```

**Note:** In CocoaPods 0.36 there is [an issue](https://github.com/CocoaPods/CocoaPods/issues/3106) that prevents using this library if you enable `use_frameworks!` in your Podfile. See also [#11](https://github.com/lysannschlegel/GooglePlusShareActivity/issues/11).

If your app is written in Swift, you must import some header files in your Objective-C bridging header.
``` objective-c
#import <GooglePlus/GooglePlus.h>
#import <GooglePlusShareActivity/GPPShareActivity.h>
```
You can find more information about Objective-C pods in Swift apps [here](https://medium.com/@stigi/swift-cocoapods-da09d8ba6dd2).

### Google+ API

Follow Steps 1 and 3 of the [Google+ iOS SDK Getting Started instructions](https://developers.google.com/+/mobile/ios/getting-started) to

  * Create an APIs Console project, and
  * Add an URL Type to your iOS app.

### Client Authentication and Sign In Callbacks

In an appropriate place, initialize the Google+ Sign In API by providing your APIs Console project's client id:

``` objective-c
#import <GooglePlus/GooglePlus.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialize Google+ Sign In API
    [GPPSignIn sharedInstance].clientID = @"xxxxxxxxxxxx.apps.googleusercontent.com";
    
    // ...
    return YES;
}
```

Your `AppDelegate` must also forward the Google+ Sign In callback URL to `GPPSignIn`:

``` objective-c
@implementation AppDelegate
// ...

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // handle Google+ Sign In callback URL
    return [[GPPSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}
```

### Share Activity Setup

Add a `GPPShareActivity` to your `UIActivityViewController`.
It accepts a string and either an image or a URL. You can also create and customize your own share builder.

``` objective-c
#import <GooglePlusShareActivity/GPPShareActivity.h>

- (void)actionButtonTapped:(UIBarButtonItem*)sender
{
    // set up items to share, in this case some text and an image
    NSArray* activityItems = @[ @"Hello Google+!", [UIImage imageNamed:@"example.jpg"] ];
    
    // URL sharing works as well. But you cannot share an image and a URL at the same time :(
    NSArray* activityItems = @[ @"Hello Google+!", [NSURL URLWithString:@"https://github.com/lysannschlegel/GooglePlusShareActivity"] ];
    
    // You can also set up a GPPShareBuilder on your own. All other items will be ignored
    id<GPPNativeShareBuilder> shareBuilder = (id<GPPNativeShareBuilder>)[GPPShare sharedInstance].nativeShareDialog;
    [shareBuilder setPrefillText:@"Hello Google+!"];
    [shareBuilder setURLToShare: [NSURL URLWithString:@"https://github.com/lysannschlegel/GooglePlusShareActivity"]];
    NSArray* activityItems = @[ @"Does not appear", shareBuilder ];
    
    
    // set up activity
    GPPShareActivity* gppShareActivity = [[GPPShareActivity alloc] init];
    gppShareActivity.canShowEmptyForm = YES;
    
    // ...
}
```

Setting `canShowEmptyForm` to `YES` will display the Google+ share activity even if no item is recognized as sharable with the activity. In this case, an empty form is shown, and the user can add text to it. (Default is `NO`, i.e. the activity is not included in the activity view.)

### Presentation on iOS < 8

If you want to support iOS 7 and below, presenting an UIActivityViewController is a bit tricky:
 
``` objective-c
// set up and present activity view controller
UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[gppShareActivity]];

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
```

Setting `activityPopoverViewController` or `activitySuperViewController` allows you to dismiss the popover controller or modal view controller before the Google+ share view is shown.

You should also consider dismissing `self.activityPopoverController` if the action is triggered again while the popover is visible.

### Presenting on iOS >= 8

While the code above works on iOS 8 as well, it can be simplified if you target only iOS 8 and later:

``` objective-c
// set up and present activity view controller
UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[gppShareActivity]];
activityViewController.popoverPresentationController.barButtonItem = sender;
[self presentViewController:activityViewController animated:YES completion:NULL];
```

### Caveats

Do not change the delegates of `GPPSignIn` and `GPPShare` while the activity is active. `GPPShareActivity` must be informed about sign in and sharing progress.
If you want to be a delegate as well, assign your delegates before starting the activity. `GPPShareActivity` will override the current delegates while performing the activity and forward all notifications to the orignal delegates.

## License

It's MIT. See LICENSE file.
