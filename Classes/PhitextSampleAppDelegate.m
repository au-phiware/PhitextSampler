//
//  PhitextSampleAppDelegate.m
//  PhitextSample
//  Created by Corin Lawson on 4/02/10.
//  Copyright Corin Lawson 2010. All rights reserved.
//

#import "PhitextSampleAppDelegate.h"
#import "PhitextSampleViewController.h"

@implementation PhitextSampleAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	//[viewController.view setFrame:CGRectMake(100, 100, 500, 500)];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	[application setApplicationSupportsShakeToEdit:YES];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
