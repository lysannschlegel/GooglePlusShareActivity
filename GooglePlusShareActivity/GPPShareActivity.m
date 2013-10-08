//
//  GPPShareActivity.m
//  GooglePlusShareActivity
//
//  Created by Lysann Schlegel on 10/6/13.
//  Copyright (c) 2013 Lysann Schlegel. All rights reserved.
//

#import "GPPShareActivity.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>


@interface GPPShareActivity ()

@property (weak, nonatomic) id<GPPSignInDelegate> userSignInDelegate;
@property (weak, nonatomic) NSObject<GPPShareDelegate>* userShareDelegate;

@property (strong, nonatomic) id<GPPNativeShareBuilder> shareBuilder;
@property (strong, nonatomic) id<GPPShareBuilder> customShareBuilder;

@end


@implementation GPPShareActivity

- (instancetype)init
{
    if (self = [super init]) {
        _canShowEmptyForm = NO;
    }
    return self;
}

- (void)dealloc
{
    [self registerSignInDelegate:NO];
    [self registerShareDelegate:NO];
}

#pragma mark - Accessors

- (id<GPPNativeShareBuilder>)shareBuilder
{
    if (!_shareBuilder) {
        _shareBuilder = (id<GPPNativeShareBuilder>)[GPPShare sharedInstance].nativeShareDialog;
    }
    return _shareBuilder;
}

#pragma mark - UIActivity implementation

- (NSString *)activityType
{
    return @"GooglePlusShareActivity";
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}
#endif

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
    if (self.canShowEmptyForm) {
        return YES;
    } else {
        for (id item in activityItems) {
            if ([item conformsToProtocol:@protocol(GPPShareBuilder)]) {
                return YES;
            } else if ([item isKindOfClass:[NSString class]]) {
                return YES;
            } else if ([item isKindOfClass:[NSURL class]]) {
                return YES;
            } else if ([item isKindOfClass:[UIImage class]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id item in activityItems) {
        if ([item conformsToProtocol:@protocol(GPPShareBuilder)]) {
            // override complete share builder
            self.customShareBuilder = item;
            
        } else if ([item isKindOfClass:[NSString class]]) {
            [self.shareBuilder setPrefillText:item];
        } else if ([item isKindOfClass:[NSURL class]]) {
            [self.shareBuilder setURLToShare:item];
        } else if ([item isKindOfClass:[UIImage class]]) {
            [self.shareBuilder attachImage:item];
        }
    }
}

- (void)performActivity
{
    if(_shareBuilder || self.customShareBuilder) {
        // Dismiss activity view controller
        if (self.activityPopoverViewController) {
            // dismiss popover (iPad)
            [self.activityPopoverViewController dismissPopoverAnimated:YES];
            id <UIPopoverControllerDelegate> delegate = [self.activityPopoverViewController delegate];
            if ([delegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)]) {
                [delegate popoverControllerDidDismissPopover:self.activityPopoverViewController];
            }
            // trigger auth and sharing
            [self performActivityInternal];
            
        } else if (self.activitySuperViewController) {
            // dismiss modal view controller (iPhone)
            [self.activitySuperViewController dismissViewControllerAnimated:YES completion:^(void){
                // trigger auth and sharing
                [self performActivityInternal];
            }];
            
        } else {
            // trigger auth and sharing
            [self performActivityInternal];
        }
        
    } else {
        NSLog(@"GPPShareActivity error: no share builder");
    }
    
    self.activityPopoverViewController = nil;
    self.activitySuperViewController = nil;
}

- (void)performActivityInternal
{
    GPPSignIn* plusSignIn = [GPPSignIn sharedInstance];
    
    // make sure we are using the login scope
    if (![plusSignIn.scopes containsObject:kGTLAuthScopePlusLogin]) {
        NSMutableArray* scopes = [[NSMutableArray alloc] initWithArray:plusSignIn.scopes];
        [scopes addObject:kGTLAuthScopePlusLogin];
        plusSignIn.scopes = scopes;
    }
    // authenticate. will call the GPPSignInDelegate methods.
    [self registerSignInDelegate:YES];
    [plusSignIn authenticate];
}

- (void)activityDidFinish:(BOOL)completed
{
    [self registerSignInDelegate:NO];
    [self registerShareDelegate:NO];
    
    self.shareBuilder = nil;
    self.customShareBuilder = nil;
    
    [super activityDidFinish:completed];
}

#pragma mark - GPPSignInDelegate

- (void) registerSignInDelegate:(BOOL)flag
{
    GPPSignIn* plusSignIn = [GPPSignIn sharedInstance];
    
    if (flag && plusSignIn.delegate != self) {
        // register
        self.userSignInDelegate = plusSignIn.delegate;
        plusSignIn.delegate = self;
    } else if (!flag && plusSignIn.delegate == self) {
        // unregister
        plusSignIn.delegate = self.userSignInDelegate;
        self.userSignInDelegate = nil;
    }
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    // forward to other delegate
    [self.userSignInDelegate finishedWithAuth:auth error:error];
    
    if (!error) {
        // we can share now. this will call the GPPShareDelegate methods.
        [self registerShareDelegate:YES];
        id<GPPShareBuilder> shareBuilder = self.customShareBuilder ? self.customShareBuilder : self.shareBuilder;
        if (![shareBuilder open]) {
            NSLog(@"GPPShareActivity error: cannot open share dialog");
            
            // complete activity
            [self activityDidFinish:NO];
        }
    } else {
        NSLog(@"GPPShareActivity authentication failure: %@", error.localizedDescription);
        
        // complete activity
        [self activityDidFinish:NO];
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    // forward to other delegate
    [self.userSignInDelegate didDisconnectWithError:error];
    
    NSLog(@"GPPShareActivity disconnected: %@", error.localizedDescription);
    
    // complete activity
    [self activityDidFinish:NO];
}

#pragma mark - GPPShareDelegate

- (void) registerShareDelegate:(BOOL)flag
{
    GPPShare* plusShare = [GPPShare sharedInstance];
    
    if (flag && plusShare.delegate != self) {
        // register
        self.userShareDelegate = plusShare.delegate;
        plusShare.delegate = self;
    } else if (!flag && plusShare.delegate == self) {
        // unregister
        plusShare.delegate = self.userShareDelegate;
        self.userSignInDelegate = nil;
    }
}

- (void)finishedSharingWithError:(NSError *)error
{
    // forward to other delegate
    if ([self.userShareDelegate respondsToSelector:@selector(finishedSharingWithError:)]) {
        [self.userShareDelegate finishedSharingWithError:error];
    } else if([self.userShareDelegate respondsToSelector:@selector(finishedSharing:)]) {
        [self.userShareDelegate finishedSharing:error == nil];
    }
    
    if (error) {
        NSLog(@"GPPShareActivity sharing failure: %@", error.localizedDescription);
    }
    
    // complete activity
    [self activityDidFinish:error == nil];
}

@end
