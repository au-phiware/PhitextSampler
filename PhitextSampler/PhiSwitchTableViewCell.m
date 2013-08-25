//
//  PhiSwitchTableViewCell.m
//  Untitled
//
//  Created by Corin Lawson on 20/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiSwitchTableViewCell.h"

@implementation PhiSwitchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier]) {
		UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
		switchView.opaque = YES;
		switchView.backgroundColor = [UIColor whiteColor];
		[switchView addTarget:self action:@selector(valueDidChange:forEvent:) forControlEvents:UIControlEventValueChanged];
		self.accessoryView = switchView;
		[switchView release];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

@end
