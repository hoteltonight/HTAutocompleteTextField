//
//  AutocompleteDemoAppDelegate.h
//  AutocompleteDemo
//
//  Created by Hezi Cohen on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutocompleteDemoViewController;

@interface AutocompleteDemoAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AutocompleteDemoViewController *viewController;

@end
