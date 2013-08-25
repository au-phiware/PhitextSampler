//
//  PhiTableViewController.h
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

#import <UIKit/UIKit.h>
#import <Phicolor/PhiColorWheelController.h>
#import <Phicolor/PhiColorPatchControl.h>

@class PhiTableViewCell;

@protocol PhiTableViewActionDelegate

@optional
- (void)tableViewCell:(UITableViewCell *)cell valueDidChange:(id)sender forEvent:(UIEvent *)event;
- (void)tableViewCell:(UITableViewCell *)cell valueDidChange:(id)sender;

@end


@interface PhiTableViewController : UITableViewController <UIScrollViewDelegate, PhiTableViewActionDelegate> {
	NSMutableDictionary *nibs;
	UITableViewCell *tableCell;
	UINavigationItem *phiNavigationItem;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *tableCell;
@property(nonatomic, readwrite, retain) UINavigationItem *navigationItem;

- (PhiTableViewCell *)loadCellWithIdentifier:(NSString *)reuseIdentifier;

@end
