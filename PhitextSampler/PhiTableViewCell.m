//
//  PhiTableCell.m
//  Untitled
//
//  Created by Corin Lawson on 20/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiTableViewCell.h"
#import "PhiTableViewController.h"

@implementation PhiTableViewCell

@synthesize owner, indexPath;

- (IBAction)valueDidChange:(id)sender forEvent:(UIEvent *)event {
	if ([owner respondsToSelector:@selector(tableViewCell:valueDidChange:forEvent:)]
		&& (!event || ![owner respondsToSelector:@selector(tableViewCell:valueDidChange:)])) {
		[owner tableViewCell:self valueDidChange:sender forEvent:event];
	} else if ([owner respondsToSelector:@selector(tableViewCell:valueDidChange:)]) {
		[owner tableViewCell:self valueDidChange:sender];
	}
}

@end
