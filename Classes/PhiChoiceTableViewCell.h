//
//  PhiChoiceTableViewCell.h
//  Untitled
//
//  Created by Corin Lawson on 20/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhiTableViewCell.h"

@class PhiChoiceTableViewController;

@interface PhiChoiceTableViewCell : PhiTableViewCell {
	NSArray *choices;
	SEL descriptionSelector;
}

@property (nonatomic, copy) NSArray *choices;
@property (nonatomic, assign) SEL descriptionSelector;

- (NSString *)textForObject:(id)object;
- (NSString *)textForObjectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObjectWithText:(NSString *)text;
- (id)selectedObjectForController:(PhiChoiceTableViewController *)sender;

@end
