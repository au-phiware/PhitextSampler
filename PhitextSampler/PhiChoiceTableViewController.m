//
//  PhiChoiceTableViewController.m
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

#import "PhiChoiceTableViewController.h"
#import "PhiTableViewController.h"
#import "PhiChoiceTableViewCell.h"

@implementation PhiChoiceTableViewController

@synthesize selectedIndices, maximumSelectedCount, minimumSelectedCount, count;

- (id)initWithStyle:(UITableViewStyle)style tableViewCell:(PhiChoiceTableViewCell *)cell {
	if (self = [super initWithStyle:style]) {
		tableViewCell = [cell retain];
		self.title = cell.textLabel.text;
		maximumSelectedCount = 1;
		minimumSelectedCount = 1;
		count = 1;
		selectedIndices = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 0)];
		NSUInteger i = [tableViewCell indexOfObjectWithText:cell.detailTextLabel.text];
		if (i != NSNotFound) {
			[selectedIndices addIndex:i];
		}
	}
	return self;
}

- (void)setSelectedIndices:(NSIndexSet *)set {
	if (selectedIndices != set) {
		if (selectedIndices) {
			[selectedIndices release];
		}
		selectedIndices = [set mutableCopy];
	}
}

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tableViewCell.choices count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if ([selectedIndices containsIndex:indexPath.row]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.textLabel.text = [tableViewCell textForObjectAtIndex:indexPath.row];
    
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
	
	if ([selectedIndices containsIndex:indexPath.row]) {
		if ([selectedIndices count] > minimumSelectedCount) {
			cell.accessoryType = UITableViewCellAccessoryNone;
			[selectedIndices removeIndex:indexPath.row];
			[tableViewCell valueDidChange:self forEvent:nil];
		}
	} else {
		if ([selectedIndices count] == maximumSelectedCount) {
			NSUInteger a = [selectedIndices indexLessThanIndex:indexPath.row];
			NSUInteger b = [selectedIndices indexGreaterThanIndex:indexPath.row];
			NSUInteger i = ABS(a) > ABS(b) ? b : a;

			if (i != NSNotFound) {
				[selectedIndices removeIndex:i];
				UITableViewCell *deselectCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
				if (deselectCell) {
					[deselectCell setAccessoryType:UITableViewCellAccessoryNone];
				}
			}
		}
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[selectedIndices addIndex:indexPath.row];
		[tableViewCell valueDidChange:self forEvent:nil];
	}
	
	[cell setSelected:NO animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	if (tableViewCell)
		[tableViewCell release];
	tableViewCell = nil;

	self.selectedIndices = nil;

    [super dealloc];
}


@end

