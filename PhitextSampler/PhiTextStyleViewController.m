//
//  PhiTextStyleViewController.m
//  Untitled
//
//  Created by Corin Lawson on 19/08/10.
//  Copyright Corin Lawson 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PhiTextStyleViewController.h"
#import <Phitext/PhiTextStyle.h>
#import <Phitext/PhiTextFont.h>
#import <Phitext/PhiTextParagraphStyle.h>
#import "PhiTableViewCell.h"
#import "PhiSliderTableViewCell.h"
#import "PhiSwitchTableViewCell.h"
#import "PhiChoiceTableViewCell.h"
#import "PhiChoiceTableViewController.h"
#import "PhiColorTableViewCell.h"
#import "PhiParagraphStyleViewController.h"
#import "PhiFontViewController.h"
#import <Phicolor/PhiColorPatchControl.h>

@implementation PhiTextStyleViewController

@synthesize textStyle;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)viewStyle {
	if (self = [super initWithStyle:viewStyle]) {
		self.title = @"Text Style";
		textStyle = [[PhiTextStyle alloc] init];
		self.contentSizeForViewInPopover = CGSizeMake(320, 480);
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		textStyle = [[PhiTextStyle alloc] init];
		self.contentSizeForViewInPopover = CGSizeMake(320, 480);
	}
	return self;
}

- (void)setTextStyle:(PhiTextStyle *)style {
	if (textStyle != style) {
		[textStyle release];
		textStyle = style;
		[textStyle retain];
		[self.tableView reloadData];
	}
}

- (void)tableViewCell:(PhiTableViewCell *)cell valueDidChange:(id)sender {
	CGFloat sliderValue = 0.0;
	if ([cell isKindOfClass:[PhiSliderTableViewCell class]]) {
		sliderValue = [[(PhiSliderTableViewCell *)cell slider] value];
	}
	
	switch (cell.indexPath.section) {
		case 0:
			switch (cell.indexPath.row) {
				case 0:
#pragma mark Font Size (Sync)
					[self.textStyle.font setSize:sliderValue];
					if (sliderValue == 0.0)
						[(UILabel *)cell.accessoryView setText:@"Default"];
					break;
				case 1:
#pragma mark Font (Sync)
					self.textStyle.font = [PhiTextFont fontWithCTFontDescriptor:[sender copyFontDescriptor] andSize:[self.textStyle.font size]];
					[[(PhiSliderTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] slider] setValue:[self.textStyle.font size]];
					break;
				default:
					break;
			}
			break;
		case 1:
			switch (cell.indexPath.row) {
				case 0:
#pragma mark Text Color (Sync)
					if ([(PhiColorPatchControl *)[cell accessoryView] color])
						self.textStyle.color = [[(PhiColorPatchControl *)[cell accessoryView] color] CGColor];
					break;
				case 1:
#pragma mark Outline Color (Sync)
					if ([(PhiColorPatchControl *)[cell accessoryView] color])
						self.textStyle.strokeColor = [[(PhiColorPatchControl *)[cell accessoryView] color] CGColor];
					break;
				case 2:
#pragma mark Underline Color (Sync)
					if ([(PhiColorPatchControl *)[cell accessoryView] color])
						self.textStyle.underlineColor = [[(PhiColorPatchControl *)[cell accessoryView] color] CGColor];
					break;
				case 3:
#pragma mark Use Curent Color (Sync)
					self.textStyle.shouldUseCurrentColor = [(UISwitch *)[cell accessoryView] isOn];
					break;
			}
			break;
		case 2:
			switch (cell.indexPath.row) {
				case 0:
#pragma mark Superscript (Sync)
					if (self.textStyle.superscript = [(UISwitch *)[cell accessoryView] isOn])
						[(UISwitch *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]] accessoryView] setOn:NO animated:YES];
					break;
				case 1:
#pragma mark Subscript (Sync)
					if (self.textStyle.subscript = [(UISwitch *)[cell accessoryView] isOn])
						[(UISwitch *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]] accessoryView] setOn:NO animated:YES];
					break;
				case 2:
#pragma mark Underline (Sync)
					self.textStyle.underlineScale = [[sender selectedIndices] firstIndex];
					break;
				case 3:
#pragma mark Underline Double (Sync)
					self.textStyle.underlineDouble = [(UISwitch *)[cell accessoryView] isOn];
					break;
				case 4:
#pragma mark Underline Pattern (Sync)
					self.textStyle.underlinePattern = [[sender selectedIndices] firstIndex] << 8;
					break;
			}
			break;
		case 3:
			switch (cell.indexPath.row) {
				case 0:
#pragma mark Stroke Width (Sync)
					self.textStyle.strokeWidth = sliderValue;
					if (sliderValue == 0.0) {
						[(UILabel *)cell.accessoryView setText:@"OFF"];
					}
					break;
				case 1:
#pragma mark Stroke Mode (Sync)
					if ([[sender selectedIndices] firstIndex]) {
						self.textStyle.strokeStyle = kPhiStrokeOnly;
					} else {
						self.textStyle.strokeStyle = kPhiStrokeAndFill;
					}
					break;
			}
			break;
		case 4:
			switch (cell.indexPath.row) {
				case 0:
#pragma mark Kern (Sync)
					self.textStyle.kern = sliderValue;
					break;
				case 1:
#pragma mark Paragraph Style (Sync)
					break;
			}
			break;
		case 5:
			switch (cell.indexPath.row) {
				case 2:
#pragma mark Character Shape (Sync)
					self.textStyle.characterShape = [[sender selectedIndices] firstIndex];
					break;
				case 0:
#pragma mark Ligatures (Sync)
					self.textStyle.ligature = [[sender selectedIndices] firstIndex];
					break;
				case 1:
#pragma mark Use Vertical Forms (Sync)
					self.textStyle.shouldUseVerticalForms = [(UISwitch *)[cell accessoryView] isOn];
					break;
			}
	}
	if (self.delegate && [self.delegate respondsToSelector:@selector(textStyle:didChange:)]) {
		[self.delegate textStyle:self.textStyle didChange:self];
	}
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 2;
		case 1:
			return 4;
		case 2:
			return 5;
		case 3:
			return 2;
		case 4:
			return 2;
		case 5:
			return 3;
		default:
			return 0;
	}
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Font Size";
		case 1:
			return @"Colors";
		case 3:
			return @"Outline Width";
		case 4:
			return @"Kerning";
		case 5:
			return @"Advanced";
		default:
			return nil;
	}
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	switch (section) {
		case 1:
			return @"With this option ON the current color of the document is used; otherwise color defaults to black.";
		case 3:
			return @"Width is specified as a percentage of font size; 3% is a typical value.";
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
#pragma mark Font Size (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
					slider = [(PhiSliderTableViewCell *)cell slider];
					[slider setMinimumValue:0.0];
					[slider setMaximumValue:144.0];
					[(PhiSliderTableViewCell *)cell setValueFormat:@"%.0fpt"];
					sliderValue = [[[self textStyle] font] size];
					[slider setValue:sliderValue];
					if (sliderValue == 0.0) {
						[(UILabel *)cell.accessoryView setText:@"Default"];
					} else
						[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
					break;
				case 1:
#pragma mark Font (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiTableCell"];
					[cell.textLabel setText:NSLocalizedString(@"Font", @"")];
					cell.detailTextLabel.text = [self.textStyle.font displayName];
					break;
			}
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
#pragma mark Text Color (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiColorTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiColorTableCell"];
					[[cell textLabel] setText:@"Text Color"];
					[(PhiColorPatchControl *)[cell accessoryView] setColor:[UIColor colorWithCGColor:self.textStyle.color]];
					break;
				case 1:
#pragma mark Outline Color (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiColorTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiColorTableCell"];
					[cell.textLabel setText:@"Outline Color"];
					[(PhiColorPatchControl *)[cell accessoryView] setColor:[UIColor colorWithCGColor:self.textStyle.strokeColor]];
					break;
				case 2:
#pragma mark Underline Color (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiColorTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiColorTableCell"];
					[cell.textLabel setText:@"Underline Color"];
					[(PhiColorPatchControl *)[cell accessoryView] setColor:[UIColor colorWithCGColor:self.textStyle.underlineColor]];
					break;
				case 3:
#pragma mark Use Curent Color (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSwitchTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSwitchTableCell"];
					[cell.textLabel setText:@"Use Current Color"];
					[(UISwitch *)[cell accessoryView] setOn:self.textStyle.shouldUseCurrentColor animated:NO];
					break;
			}
			break;
		case 2:
			switch (indexPath.row) {
				case 0:
#pragma mark Superscript (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSwitchTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSwitchTableCell"];
					[cell.textLabel setText:@"Superscript"];
					[(UISwitch *)[cell accessoryView] setOn:self.textStyle.superscript animated:NO];
					break;
				case 1:
#pragma mark Subscript (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSwitchTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSwitchTableCell"];
					[cell.textLabel setText:@"Subscript"];
					[(UISwitch *)[cell accessoryView] setOn:self.textStyle.subscript animated:NO];
					break;
				case 2:
#pragma mark Underline (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiChoiceTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiChoiceTableCell"];
					choices = [NSMutableArray arrayWithCapacity:8];
					[choices addObject:@"OFF"];
					[choices addObject:@"XXL"];
					[choices addObject:@"XL"];
					[choices addObject:@"Long"];
					[choices addObject:@"Medium"];
					[choices addObject:@"Short"];
					[choices addObject:@"XS"];
					[choices addObject:@"XXS"];
					[(PhiChoiceTableViewCell *)cell setChoices:choices];
					[cell.textLabel setText:@"Underline"];
					if (self.textStyle.underlined) {
						[[cell detailTextLabel] setText:[choices objectAtIndex:self.textStyle.underlineScale]];
					} else {
						[[cell detailTextLabel] setText:@"OFF"];
					}
					break;
				case 3:
#pragma mark Underline Double (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSwitchTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSwitchTableCell"];
					[cell.textLabel setText:@"Double Underline"];
					[(UISwitch *)[cell accessoryView] setOn:self.textStyle.underlineDouble animated:NO];
					break;
				case 4:
#pragma mark Underline Pattern (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiChoiceTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiChoiceTableCell"];
					choices = [NSMutableArray arrayWithCapacity:5];
					[choices addObject:@"\u2013\u2013\u2013\u2013\u2013\u2013\u2013\u2013"];
					[choices addObject:@"\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022"];
					[choices addObject:@"\u2013 \u2013 \u2013 \u2013 \u2013"];
					[choices addObject:@"\u2013 \u2022 \u2013 \u2022 \u2013 \u2022"];
					[choices addObject:@"\u2013 \u2022 \u2022 \u2013 \u2022 \u2022"];
					[(PhiChoiceTableViewCell *)cell setChoices:choices];
					[[cell textLabel] setText:@"Line Pattern"];
					[[cell detailTextLabel] setText:[choices objectAtIndex:self.textStyle.underlinePattern >> 8]];
					break;
			}
			break;
		case 3:
			switch (indexPath.row) {
				case 0:
#pragma mark Stroke Width (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
					slider = [(PhiSliderTableViewCell *)cell slider];
					[slider setMinimumValue:0.0];
					[slider setMaximumValue:100.0];
					[(PhiSliderTableViewCell *)cell setValueFormat:@"%.0f%%"];
					sliderValue = self.textStyle.strokeWidth;
					[slider setValue:sliderValue];
					if (sliderValue == 0.0) {
						[(UILabel *)cell.accessoryView setText:@"OFF"];
					} else {
						[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
					}
					break;
				case 1:
#pragma mark Stroke Mode (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiChoiceTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiChoiceTableCell"];
					choices = [NSMutableArray arrayWithCapacity:2];
					[choices addObject:@"Outline And Fill"];
					[choices addObject:@"Outline Only"];
					[(PhiChoiceTableViewCell *)cell setChoices:choices];
					[cell.textLabel setText:@"Outline Style"];
					if (self.textStyle.strokeStyle == kPhiStrokeOnly) {
						[[cell detailTextLabel] setText:[choices objectAtIndex:1]];
					} else {
						[[cell detailTextLabel] setText:[choices objectAtIndex:0]];
					}
					break;
			}
			break;
		case 4:
			switch (indexPath.row) {
				case 0:
#pragma mark Kern (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSliderTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSliderTableCell"];
					slider = [(PhiSliderTableViewCell *)cell slider];
					[slider setMinimumValue:-1.0];
					[slider setMaximumValue:1.0];					
					[(PhiSliderTableViewCell *)cell setValueFormat:@"%.1f"];
					sliderValue = self.textStyle.kern;
					[slider setValue:sliderValue];
					[(UILabel *)cell.accessoryView setText:[NSString stringWithFormat:[(PhiSliderTableViewCell *)cell valueFormat], sliderValue]];
					break;
				case 1:
#pragma mark Paragraph Style (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiTableCell"];
					[cell.textLabel setText:@"Paragraph Style"];
					cell.detailTextLabel.text = nil;
					break;
			}
			break;
		case 5:
			switch (indexPath.row) {
				case 2:
#pragma mark Character Shape (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiChoiceTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiChoiceTableCell"];
					choices = [NSMutableArray arrayWithCapacity:12];
					[choices addObject:@"None"];
					[choices addObject:@"Traditional"];
					[choices addObject:@"Simplified"];
					[choices addObject:@"JIS1978"];
					[choices addObject:@"JIS1983"];
					[choices addObject:@"JIS1990"];
					[choices addObject:@"1st Alternative Traditional"];
					[choices addObject:@"2nd Alternative Traditional"];
					[choices addObject:@"3rd Alternative Traditional"];
					[choices addObject:@"4th Alternative Traditional"];
					[choices addObject:@"5th Alternative Traditional"];
					[choices addObject:@"Expert"];
					[(PhiChoiceTableViewCell *)cell setChoices:choices];
					[cell.textLabel setText:@"Character Shape"];
					[[cell detailTextLabel] setText:[choices objectAtIndex:self.textStyle.characterShape]];
					break;
				case 0:
#pragma mark Ligatures (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiChoiceTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiChoiceTableCell"];
					choices = [NSMutableArray arrayWithCapacity:3];
					[choices addObject:@"Only Essential Ligatures"];
					[choices addObject:@"Standard Ligatures"];
					[choices addObject:@"All Ligatures"];
					[(PhiChoiceTableViewCell *)cell setChoices:choices];
					[cell.textLabel setText:@"Ligatures"];
					[[cell detailTextLabel] setText:[choices objectAtIndex:self.textStyle.ligature]];
					break;
				case 1:
#pragma mark Use Vertical Forms (Load)
					if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiSwitchTableCell"]))
						cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiSwitchTableCell"];
					[cell.textLabel setText:@"Use Vertical Forms"];
					[(UISwitch *)[cell accessoryView] setOn:self.textStyle.shouldUseVerticalForms animated:NO];
					break;
			}
	}
	[cell setIndexPath:indexPath];

    return cell;
}

/*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	CGFloat height = cell.frame.size.height;
	return height;
}
/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	if ([@"PhiChoiceTableCell" isEqual:cell.reuseIdentifier]) {
		return indexPath;
	}
	return nil;
}
/**/

/*/
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
/**/


/*/
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
/**/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	UITableViewController *detailViewController = nil;
	
	if (indexPath.section == 0 && indexPath.row == 1) {
		detailViewController = [[PhiFontViewController alloc] initWithStyle:UITableViewStyleGrouped tableViewCell:(PhiChoiceTableViewCell *)cell];
		[(PhiFontViewController *)detailViewController setFontDescriptor:[self.textStyle.font copyCTFontDescriptor]];
	} else if (indexPath.section == 4 && indexPath.row == 1) {
		detailViewController = [[PhiParagraphStyleViewController alloc] initWithStyle:UITableViewStyleGrouped tableViewCell:(PhiChoiceTableViewCell *)cell];
		[(PhiParagraphStyleViewController *)detailViewController setParagraphStyle:self.textStyle.paragraphStyle];
	} else {
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	}

	if (detailViewController) {
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
		[cell setNeedsDisplay];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
}


- (void)dealloc {
	if (textStyle) {
		[textStyle release];
		textStyle = nil;
	}
    [super dealloc];
}


@end

