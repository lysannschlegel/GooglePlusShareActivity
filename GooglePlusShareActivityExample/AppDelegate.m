//
//  AppDelegate.m
//  GooglePlusShareActivityExample
//
//  Created by Lysann Schlegel on 10/6/13.
//  Copyright (c) 2013 Lysann Schlegel. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"

#import <GooglePlus/GooglePlus.h>


#define GOOGLE_PLUS_CLIENT_ID @"960790927266.apps.googleusercontent.com"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialize Google+ Sign In API
    [self initGooglePlusSignIn];
    
    // init UI
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RootViewController* rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    // show UI
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initGooglePlusSignIn
{
    [GPPSignIn sharedInstance].clientID = GOOGLE_PLUS_CLIENT_ID;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // handle Google+ Sign In callback URL
    return [[GPPSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
