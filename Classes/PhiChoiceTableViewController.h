//
//  PhiChoiceTableViewController.h
//  Untitled
//
//  Created by Corin Lawson on 20/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhiChoiceTableViewCell;

@interface PhiChoiceTableViewController : UITableViewController {
	PhiChoiceTableViewCell *tableViewCell;
	NSMutableIndexSet *selectedIndices;
	NSUInteger maximumSelectedCount;
	NSUInteger minimumSelectedCount;
	NSUInteger count;
}

@property (nonatomic, copy) NSIndexSet *selectedIndices;
@property (nonatomic, assign) NSUInteger maximumSelectedCount;
@property (nonatomic, assign) NSUInteger minimumSelectedCount;
@property (nonatomic, readonly) NSUInteger count;

- (id)initWithStyle:(UITableViewStyle)style tableViewCell:(PhiChoiceTableViewCell *)cell;

@end
