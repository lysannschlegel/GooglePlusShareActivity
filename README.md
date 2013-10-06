This library provides a UIActivity subclass for Google+ sharing. It uses the native share builder API from the official Google+ iOS SDK for sharing, and the GPPSignIn API for signing in.


## Usage

Follow Steps 1 and 4 of the [Google+ iOS SDK Getting Started instructions](https://developers.google.com/+/mobile/ios/getting-started) to

  * Create an APIs Console project, and
  * Add an URL Type to your iOS app.

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

Add a `GPPShareActivity` to your `UIActivityViewController`.
It accepts a string and either an image or a URL. You can also create and customize your own share builder.

``` objective-c
// set up items to share, in this case some text and an image
NSArray* activityItems = @[ @"Hello Google+!", [UIImage imageNamed:@"example.jpg"] ];

// URL sharing works as well. But you cannot share an image and a URL at the same time :(
//NSArray* activityItems = @[ @"Hello Google+!", [NSURL URLWithString:@"https://github.com/lysannschlegel/GooglePlusShareActivity"] ];

// You can also set up a GPPShareBuilder on your own. All other items will be ignored
//id<GPPNativeShareBuilder> shareBuilder = (id<GPPNativeShareBuilder>)[GPPShare sharedInstance].nativeShareDialog;
//[shareBuilder setPrefillText:@"Hello Google+!"];
//[shareBuilder setURLToShare: [NSURL URLWithString:@"https://github.com/lysannschlegel/GooglePlusShareActivity"]];
//NSArray* activityItems = @[ @"Does not appear", shareBuilder ];

// set up and present activity view controller
GPPShareActivity* gppShareActivity = [[GPPShareActivity alloc] init];
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

Setting `canShowEmptyForm` to `YES` will display the Google+ share activity even if no item is recognized as sharable with the activity. In this case, an empty form is shown, and the user can add text to it. (Default is `NO`, i.e. the activity is not included in the activity view.)

For a complete example see `GooglePlusShareActivityExample/GooglePlusShareActivityExample.xcworkspace`.


## Installation

For [CocoaPods](http://cocoapods.org/) there is a Podspec in this repository.
```
pod 'GooglePlusShareActivity', :podfile => '/path/to/GooglePlusShareActivity.podspec'
```


## License

It's MIT. See LICENSE file.
