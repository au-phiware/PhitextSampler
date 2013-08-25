//
//  PhiTableViewController.h
//  Untitled
//
//  Created by Corin Lawson on 20/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Phicolor/PhiColorWheelController.h>
#import <Phicolor/PhiColorPatchControl.h>

@class PhiTableViewCell;

@protocol PhiTableViewActionDelegate

@optional
- (void)tableViewCell:(UITableViewCell *)cell valueDidChange:(id)sender forEvent:(UIEvent *)event;
- (void)tableViewCell:(UITableViewCell *)cell valueDidChange:(id)sender;

@end


@interface PhiTableViewController : UITableViewController <UIScrollViewDelegate, PhiTableViewActionDelegate> {
	NSMutableDictionary *nibs;
	UITableViewCell *tableCell;
	UINavigationItem *phiNavigationItem;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *tableCell;
@property(nonatomic, readwrite, retain) UINavigationItem *navigationItem;

- (PhiTableViewCell *)loadCellWithIdentifier:(NSString *)reuseIdentifier;

@end
