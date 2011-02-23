//
//  PhitextSampleAppDelegate.h
//  PhitextSample
//  Created by Corin Lawson on 4/02/10.
//  Copyright Corin Lawson 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhitextSampleViewController;

@interface PhitextSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PhitextSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PhitextSampleViewController *viewController;

@end

