//
//  PhiChoiceTableViewCell.m
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

#import "PhiChoiceTableViewCell.h"
#import "PhiChoiceTableViewController.h"

@implementation PhiChoiceTableViewCell

@synthesize choices, descriptionSelector;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier]) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		descriptionSelector = @selector(description);
	}
	return self;
}

- (NSArray *)choices {
	if (!choices) {
		return [NSArray array];
	}
	return [[choices copy] autorelease];
}

- (id)selectedObjectForController:(PhiChoiceTableViewController *)sender {
	return [self.choices objectAtIndex:[sender.selectedIndices firstIndex]];
}
- (NSString *)textForObject:(id)object {
	SEL selector = self.descriptionSelector;
	if (selector)
		return [object performSelector:selector];
	else
		return [object description];
}
- (NSString *)textForObjectAtIndex:(NSUInteger)index {
	return [self textForObject:[self.choices objectAtIndex:index]];
}
- (NSUInteger)indexOfObjectWithText:(NSString *)text {
	NSArray *array = self.choices;
	for (NSUInteger i = 0; i < [array count]; i++)
		if ([text isEqual:[self textForObject:[array objectAtIndex:i]]])
			return i;
	return NSNotFound;
}
- (IBAction)valueDidChange:(PhiChoiceTableViewController *)sender forEvent:(UIEvent *)event {
	self.detailTextLabel.text = [self textForObject:[self selectedObjectForController:sender]];
	[super valueDidChange:sender forEvent:(UIEvent *)event];
	[self setNeedsLayout];
}

- (void)dealloc {
	if (choices)
		[choices release];
	choices = nil;
	
    [super dealloc];
}

@end
