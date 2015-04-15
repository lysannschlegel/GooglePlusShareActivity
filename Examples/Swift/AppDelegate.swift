//
//  AppDelegate.swift
//  GooglePlusShareActivityExampleSwift
//
//  Created by Lysann Schlegel on 4/15/15.
//  Copyright (c) 2015 Lysann Schlegel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        // initialize Google+ Sign In API
        self.initializeGooglePlusSignIn()

        // init UI
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let rootViewController = RootViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.translucent = false
        self.window?.rootViewController = navigationController

        // show UI
        self.window?.makeKeyAndVisible()
        return true
    }

    func initializeGooglePlusSignIn()
    {
        GPPSignIn.sharedInstance().clientID = "960790927266-27gare2mst5gjtue59u6iroi5fncs2e4.apps.googleusercontent.com"
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
    {
        // handle Google+ Sign In callback URL
        return GPPSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
}
