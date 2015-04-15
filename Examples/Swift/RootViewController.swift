//
//  RootViewController.swift
//  GooglePlusShareActivityExampleSwift
//
//  Created by Lysann Schlegel on 4/15/15.
//  Copyright (c) 2015 Lysann Schlegel. All rights reserved.
//

import UIKit

class RootViewController: UIViewController
{
    var image: UIImage?

    override func loadView()
    {
        self.view = UIView()
        self.view.backgroundColor = UIColor.whiteColor()

        self.image  = UIImage(named: "example.jpg")
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.image = self.image
        self.view.addSubview(imageView)

        // lay out
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0),
        ])

        // navigation bar
        self.navigationItem.title = "Google+ Sharing"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonClicked:")
    }

    func shareButtonClicked(sender: UIBarButtonItem?)
    {
        // This works on iOS 8 and above only.
        // See the solution from the Objective-C Example project if you target
        // older iOS versions as well.

        let gppShareActivity = GPPShareActivity()

        let activityViewController = UIActivityViewController(activityItems: self.activityItems(), applicationActivities: [gppShareActivity])
        activityViewController.popoverPresentationController?.barButtonItem = sender

        self.presentViewController(activityViewController, animated: true, completion: nil)
    }

    func activityItems() -> [AnyObject]
    {
        // set up items to share, in this case some text and an image
        let activityItems = [ "Hello Google+!", self.image! ]

        // URL sharing works as well. But you cannot share an image and a URL at the same time :(
        //let activityItems = [ "Hello Google+!", NSURL(string: "https://github.com/lysannschlegel/GooglePlusShareActivity")! ]

        // If a file path URL is passed, it must point to an image. It is attached as if you used a UIImage directly.
        //let activityItems = [ "Hello Google+!", NSBundle.mainBundle().URLForResource("example", withExtension: "jpg")! ]

        // You can also set up a GPPShareBuilder on your own. All other items will be ignored
        //let shareBuilder = GPPShare.sharedInstance().nativeShareDialog()
        //shareBuilder.setPrefillText("Hello Google+!")
        //shareBuilder.setURLToShare(NSURL(string: "https://github.com/lysannschlegel/GooglePlusShareActivity"))
        //let activityItems : [AnyObject] = [ "Does not appear", shareBuilder ]
        
        return activityItems
    }
}
