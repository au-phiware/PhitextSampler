//
//  PhiSliderTableViewCell.m
//  PhitextSampler
//
// Copyright 2013 Corin Lawson
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
