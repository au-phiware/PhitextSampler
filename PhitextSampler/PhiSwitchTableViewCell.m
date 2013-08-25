//
//  PhiSwitchTableViewCell.m
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
