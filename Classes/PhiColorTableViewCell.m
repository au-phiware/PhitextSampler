//
//  PhiColorTableViewCell.m
//  Untitled
//
//  Created by Corin Lawson on 21/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiColorTableViewCell.h"
#import <Phitext/PhiColorPatchControl.h>

@implementation PhiColorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		PhiColorPatchControl *patchView = [[PhiColorPatchControl alloc] initWithFrame:CGRectMake(271.0, 12.5, 21.0, 21.0)];
		patchView.opaque = YES;
		patchView.backgroundColor = [UIColor whiteColor];
		[patchView addTarget:self action:@selector(colorDidChange) forControlEvents:UIControlEventValueChanged];
		self.accessoryView = patchView;
		[patchView release];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)colorDidChange {
	[self valueDidChange:[self accessoryView] forEvent:nil];
}

- (void)setSelected:(BOOL)select animated:(BOOL)animate {
	if (select && !self.selected && [[self accessoryView] canBecomeFirstResponder] && ![[self accessoryView] isFirstResponder]) {
		if ([(PhiColorPatchControl *)[self accessoryView] becomeFirstResponderAnimated:animate])
			[super setSelected:select animated:animate];
	} else if (!select && self.selected && [[self accessoryView] canResignFirstResponder] && [[self accessoryView] isFirstResponder]) {
		if ([(PhiColorPatchControl *)[self accessoryView] resignFirstResponderAnimated:animate])
			[super setSelected:select animated:animate];
	} else {
		[super setSelected:select animated:animate];
	}
}

- (void)dealloc {
	[(UIControl *)self.accessoryView removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
	[super dealloc];
}

@end
