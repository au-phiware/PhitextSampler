//
//  PhiChoiceTableViewCell.m
//  Untitled
//
//  Created by Corin Lawson on 20/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
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
