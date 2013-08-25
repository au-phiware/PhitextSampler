//
//  PhiParagraphStyleViewController.m
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

#import "PhiParagraphStyleViewController.h"
#import "PhiSliderTableViewCell.h"
#import "PhiSwitchTableViewCell.h"
#import "PhiChoiceTableViewCell.h"
#import "PhiColorTableViewCell.h"
#import "PhiChoiceTableViewController.h"
#import <Phitext/PhiTextParagraphStyle.h>

@implementation PhiParagraphStyleViewController

@synthesize paragraphStyle;

- (id)initWithStyle:(UITableViewStyle)style tableViewCell:(PhiTableViewCell *)cell {
	if (self = [super initWithStyle:style]) {
		if (cell) {
			tableViewCell = [cell retain];
			self.title = [cell.textLabel text];
		} else {
			self.title = @"Paragraph Style";
		}
	}
	return self;
}

- (void)tableViewCell:(PhiTableViewCell *)cell valueDidChange:(id)sender forEvent:(UIEvent *)event {
	NSIndexPath *indexPath = [cell indexPath];
	CGFloat sliderValue = 0.0;
	UISlider *slider = nil;
	if ([cell isKindOfClass:[PhiSliderTableViewCell class]]) {
		slider = [(PhiSliderTableViewCell *)cell slider];
		sliderValue = [slider value];
	}
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					self.paragraphStyle.alignment = [[sender selectedIndices] firstIndex];
					break;
				case 1:
					self.paragraphStyle.lineBreakMode = [[sender selectedIndices] firstIndex];
					break;
				case 2:
					self.paragraphStyle.baseWritingDirection = [[sender selectedIndices] firstIndex] - 1;
					break;
			}
			break;
		case 1:
			self.paragraphStyle.firstLineHeadIndent = sliderValue;
			break;
		case 2:
			self.paragraphStyle.headIndent = sliderValue;
			break;
		case 3:
			self.paragraphStyle.tailIndent = sliderValue;
			break;
		case 4:
			self.paragraphStyle.defaultTabInterval = sliderValue;
			break;
		case 5:
			self.paragraphStyle.lineHeightMultiple = sliderValue / 100.0;
			if (sliderValue == 0.0) {
				[(UILabel *)cell.accessoryView setText:@"None"];
				[slider setValue:100.0];
			}
			break;
		case 6:
			self.paragraphStyle.maximumLineHeight = sliderValue;
			if (sliderValue == 0.0)
				[(UILabel *)cell.accessoryView setText:@"N/A"];
			break;
		case 7:
			self.paragraphStyle.minimumLineHeight = sliderValue;
			if (sliderValue == 0.0)
				[(UILabel *)cell.accessoryView setText:@"N/A"];
			break;
		case 8:
			self.paragraphStyle.lineSpacing = sliderValue;
			break;
		case 9:
			self.paragraphStyle.paragraphSpacing = sliderValue;
			break;
		case 10:
			self.paragraphStyle.paragraphSpacingBefore = sliderValue;
			break;
	}
	[tableViewCell valueDidChange:self forEvent:event];
	[tableViewCell setNeedsLayout];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 11;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 3;
		default:
			return 1;
	}
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 1:
			return @"First Line Head Indent";
		case 2:
			return @"Head Indent";
		case 3:
			return @"Tail Indent";
		case 4:
			return @"Default Tab Interval";
		case 5:
			return @"Line Spacing (Multiple)";
		case 6:
			return @"Max. Line Height";
		case 7:
			return @"Min. Line Height";
		case 8:
			return @"Line Spacing (Exact)";
		case 9:
			return @"Paragraph Spacing (After)";
		case 10:
			return @"Paragraph Spacing (Before)";
		default:
			return nil;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	PhiTableViewCell *cell = nil;
	NSMutableArray *choices = nil;
	UISlider *slider;
 	CGFloat sliderValue;
   
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiChoiceTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiChoiceTableCell"];
					choices = [NSMutableArray arrayWithCapacity:5];
					[choices addObject:@"Left Aligned"];
					[choices addObject:@"Right Aligned"];
					[choices addObject:@"Centered"];
					[choices addObject:@"Justified"];
					[choices addObject:@"Natural"];
					[cell.textLabel setText:@"Alignment"];
					[[cell detailTextLabel] setText:[choices objectAtIndex:self.paragraphStyle.alignment]];
					[(PhiChoiceTableViewCell *)cell setChoices:choices];
					break;
				case 1:
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiChoiceTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiChoiceTableCell"];
					choices = [NSMutableArray arrayWithCapacity:6];
					[choices addObject:@"Word Wrapping"];
					[choices addObject:@"Character Wrapping"];
					[choices addObject:@"Clipping"];
					[choices addObject:@"Head Truncating"];
					[choices addObject:@"Tail Truncating"];
					[choices addObject:@"Middle Truncating"];
					[cell.textLabel setText:@"Line Break Mode"];
					[[cell detailTextLabel] setText:[choices objectAtIndex:self.paragraphStyle.lineBreakMode]];
					[(PhiChoiceTableViewCell *)cell setChoices:choices];
					break;
				case 2:
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiChoiceTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiChoiceTableCell"];
					choices = [NSMutableArray arrayWithCapacity:3];
					[choices addObject:@"Natural"];
					[choices addObject:@"Left to Right"];
					[choices addObject:@"Right to Left"];
					[cell.textLabel setText:@"Writing Direction"];
					[[cell detailTextLabel] setText:[choices objectAtIndex:1 + self.paragraphStyle.baseWritingDirection]];
					[(PhiChoiceTableViewCell *)cell setChoices:choices];
					break;
			}
			break;
		case 1:
			// First Line Head Indent
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:432.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.0fpt"];
			sliderValue = self.paragraphStyle.firstLineHeadIndent;
			[slider setValue:sliderValue];
			[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			break;
		case 2:
			// Head Indent
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:432.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.0fpt"];
			sliderValue = self.paragraphStyle.headIndent;
			[slider setValue:sliderValue];
			[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			break;
		case 3:
			// Tail Indent
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:-432.0];
			[slider setMaximumValue:432.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.0fpt"];
			sliderValue = self.paragraphStyle.tailIndent;
			[slider setValue:sliderValue];
			[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			break;
		case 4:
			// Default Tab Interval
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:216.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.0fpt"];
			sliderValue = self.paragraphStyle.defaultTabInterval;
			[slider setValue:sliderValue];
			[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			break;
		case 5:
			// Line Height Multiple
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:500.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.0f%%"];
			sliderValue = self.paragraphStyle.lineHeightMultiple * 100.0;
			[slider setValue:sliderValue];
			if (sliderValue == 0.0) {
				[(UILabel *)cell.accessoryView setText:@"None"];
				[slider setValue:100.0];
			} else {
				[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			}
			break;
		case 6:
			// Max. Line Height
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:432.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.0fpt"];
			sliderValue = self.paragraphStyle.maximumLineHeight;
			[slider setValue:sliderValue];
			if (sliderValue == 0.0) {
				[(UILabel *)cell.accessoryView setText:@"N/A"];
			} else {
				[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			}
			break;
		case 7:
			// Min. Line Height
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:432.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.0fpt"];
			sliderValue = self.paragraphStyle.minimumLineHeight;
			[slider setValue:sliderValue];
			if (sliderValue == 0.0) {
				[(UILabel *)cell.accessoryView setText:@"N/A"];
			} else {
				[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			}
			break;
		case 8:
			// Line Spacing (Leading)
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:144.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.1fpt"];
			sliderValue = self.paragraphStyle.lineSpacing;
			[slider setValue:sliderValue];
			[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			break;
		case 9:
			// Paragraph Spacing
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:144.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.1fpt"];
			sliderValue = self.paragraphStyle.paragraphSpacing;
			[slider setValue:sliderValue];
			[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			break;
		case 10:
			// Paragraph Spacing Before
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
			slider = [(PhiSliderTableViewCell *)cell slider];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:144.0];
			[(PhiSliderTableViewCell *)cell setValueFormat:@"%.1fpt"];
			sliderValue = self.paragraphStyle.paragraphSpacingBefore;
			[slider setValue:sliderValue];
			[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
			break;
	}
	[cell setIndexPath:indexPath];
	
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
	
    [super dealloc];
}


@end

