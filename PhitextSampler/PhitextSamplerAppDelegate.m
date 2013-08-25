//
//  PhitextSamplerAppDelegate.m
//  PhitextSampler
//
//  Created by Corin Lawson on 25/08/13.
//  Copyright (c) 2013 Phiware. All rights reserved.
//

#import "PhitextSamplerAppDelegate.h"

@implementation PhitextSamplerAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setApplicationSupportsShakeToEdit:YES];
    return YES;
}

@end
