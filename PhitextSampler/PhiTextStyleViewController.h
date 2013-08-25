//
//  RootViewController.h
//  Untitled
//
//  Created by Corin Lawson on 19/08/10.
//  Copyright Corin Lawson 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhiTableViewController.h"

@class PhiTextStyle;

@interface PhiTextStyleViewController : PhiTableViewController {
	PhiTextStyle *textStyle;
	id delegate;
}

@property (nonatomic, retain) IBOutlet PhiTextStyle *textStyle;
@property (nonatomic, assign) id delegate;

@end
