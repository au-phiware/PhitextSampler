//
//  PhiColorTableViewCell.m
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

#import "PhiColorTableViewCell.h"
#import <Phicolor/PhiColorPatchControl.h>

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
