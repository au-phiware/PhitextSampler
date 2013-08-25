//
//  PhiTableViewController.m
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

#import "PhiTableViewController.h"
#import "PhiTableViewCell.h"
#import "PhiSliderTableViewCell.h"
#import "PhiSwitchTableViewCell.h"
//#import "PhiSegmentedTableViewCell.h"
#import "PhiChoiceTableViewCell.h"
#import "PhiChoiceTableViewController.h"
#import "PhiFontDescriptiorTableViewCell.h"
#import "PhiColorTableViewCell.h"

@interface PhiTableViewController ()

@property (nonatomic, retain) NSMutableDictionary *nibs;

@end


@implementation PhiTableViewController

@synthesize tableCell;
@synthesize nibs;

- (UINavigationItem *)navigationItem {
	if (!phiNavigationItem)
		phiNavigationItem = [super navigationItem];

	return phiNavigationItem;
}
- (void)setNavigationItem:(UINavigationItem *)item {
	if (item != phiNavigationItem) {
		NSAssert(!phiNavigationItem, @"Can not set the navigation item because it has already been created for this view controller.");
		phiNavigationItem = [item retain];
	}
}

#pragma mark -
#pragma mark Table view data source

- (PhiTableViewCell *)loadCellWithIdentifier:(NSString *)reuseIdentifier {
	PhiTableViewCell *cell = nil;
	if ([@"PhiSliderTableCell" isEqual:reuseIdentifier]) {
		[[NSBundle mainBundle] loadNibNamed:@"PhiSliderTableViewCell" owner:self options:nil];
		cell = [[tableCell retain] autorelease];
		self.tableCell = nil;
		return cell;
	} else if ([@"PhiSwitchTableCell" isEqual:reuseIdentifier]) {
		cell = [[[PhiSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
//	} else if ([@"PhiSegmentedTableCell" isEqual:reuseIdentifier]) {
//		cell = [[[PhiSegmentedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
	} else if ([@"PhiChoiceTableCell" isEqual:reuseIdentifier]) {
		cell = [[[PhiChoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
	} else if ([@"PhiColorTableCell" isEqual:reuseIdentifier]) {
		cell = [[[PhiColorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
	} else if ([@"PhiFontDescriptiorTableCell" isEqual:reuseIdentifier]) {
		cell = [[[PhiFontDescriptiorTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
	} else if ([@"PhiTableCell" isEqual:reuseIdentifier]) {
		cell = [[[PhiTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	[cell setOwner:self];
	return cell;
}

- (NSMutableDictionary *)nibs {
	if (!nibs) {
		nibs = [NSMutableDictionary dictionaryWithCapacity:3];
	}
	return nibs;
}

/*/ Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	UITableViewController *detailViewController = nil;
	
	if ([cell isKindOfClass:[PhiChoiceTableViewCell class]]) {
		detailViewController = [[PhiChoiceTableViewController alloc] initWithStyle:UITableViewStyleGrouped tableViewCell:(PhiChoiceTableViewCell *)cell];
	}
	
	if (detailViewController) {
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
		[cell setNeedsDisplay];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if ([cell isKindOfClass:[PhiColorTableViewCell class]]) {
		[[cell accessoryView] resignFirstResponder];
	}
}

#pragma mark -
#pragma mark Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	PhiColorWheelController *wheel = [PhiColorWheelController sharedColorWheelController];
	if (wheel.wheelVisible) {
		[wheel setWheelVisible:NO animated:YES];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
	self.nibs = nil;
}

- (void)viewDidUnload {
	self.tableCell = nil;
	self.nibs = nil;
}


- (void)dealloc {
	self.tableCell = nil;
	self.nibs = nil;
	
    [super dealloc];
}


@end

