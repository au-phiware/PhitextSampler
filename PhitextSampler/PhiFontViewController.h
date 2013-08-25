//
//  PhiFontViewController.h
//  Untitled
//
//  Created by Corin Lawson on 23/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "PhiTableViewController.h"

@class PhiTableViewCell;

@interface PhiFontViewController : PhiTableViewController {
	PhiTableViewCell *tableViewCell;
	NSArray *fontFamilyNames;
	CTFontDescriptorRef fontDescriptor;
}

- (id)initWithStyle:(UITableViewStyle)style tableViewCell:(PhiTableViewCell *)cell;

- (void)setFontDescriptor:(CTFontDescriptorRef)aFontDescriptor;
- (CTFontDescriptorRef)copyFontDescriptor;

@end
