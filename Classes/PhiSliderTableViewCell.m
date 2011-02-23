//
//  PhiSliderTableViewCell.m
//  Untitled
//
//  Created by Corin Lawson on 20/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiSliderTableViewCell.h"

@implementation PhiSliderTableViewCell

@synthesize slider, valueFormat;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.valueFormat = @"%.1f";
	}
	return self;
}

- (IBAction)valueDidChange:(UISlider *)sender forEvent:(UIEvent *)event {
	[self performSelectorOnMainThread:@selector(updateValueLabel) withObject:nil waitUntilDone:YES];
	[super valueDidChange:sender forEvent:event];
}

- (void)updateValueLabel {
	NSString *text;
	text = [NSString stringWithFormat:self.valueFormat, [self.slider value]];
	[(UILabel *)self.accessoryView setText:text];
}

- (void)dealloc {
	self.slider = nil;
	self.valueFormat = nil;
	
	[super dealloc];
}

@end
