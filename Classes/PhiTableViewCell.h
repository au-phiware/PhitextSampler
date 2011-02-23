//
//  PhiTableCell.h
//  Untitled
//
//  Created by Corin Lawson on 20/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhiTableViewController;

@interface PhiTableViewCell : UITableViewCell {
	PhiTableViewController *owner;
	NSIndexPath *indexPath;
}

@property (nonatomic, assign) IBOutlet PhiTableViewController *owner;
@property (nonatomic, retain) NSIndexPath *indexPath;

- (IBAction)valueDidChange:(id)sender forEvent:(UIEvent *)event;

@end
