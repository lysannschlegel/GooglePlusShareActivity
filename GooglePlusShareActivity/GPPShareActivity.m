//
//  GPPShareActivity.m
//  GooglePlusShareActivity
//
//  Created by Lysann Schlegel on 10/6/13.
//  Copyright (c) 2013 Lysann Schlegel. All rights reserved.
//

#import "GPPShareActivity.h"

@implementation GPPShareActivity

- (NSString *)activityType
{
    return @"GooglePlusShareActivity";
}

- (NSString *)activityTitle
{
    return @"Google+";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"GPPShareActivity"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    // TODO
    return YES;
}

- (void)performActivity
{
    // TODO
    [self activityDidFinish:NO];
}

@end
