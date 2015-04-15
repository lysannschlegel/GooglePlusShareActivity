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
}
