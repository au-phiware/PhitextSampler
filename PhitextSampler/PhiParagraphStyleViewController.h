//
//  PhiParagraphStyleViewController.h
//  Untitled
//
//  Created by Corin Lawson on 23/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhiTableViewController.h"

@class PhiTableViewCell;
@class PhiTextParagraphStyle;

@interface PhiParagraphStyleViewController : PhiTableViewController {
	PhiTableViewCell *tableViewCell;
	PhiTextParagraphStyle *paragraphStyle;
}

- (id)initWithStyle:(UITableViewStyle)style tableViewCell:(PhiTableViewCell *)cell;

@property (nonatomic, retain) IBOutlet PhiTextParagraphStyle *paragraphStyle;

@end
