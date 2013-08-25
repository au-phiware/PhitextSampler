//
//  PhiFontViewController.m
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

#import "PhiFontViewController.h"
#import "PhiSliderTableViewCell.h"
#import "PhiSwitchTableViewCell.h"
#import "PhiChoiceTableViewCell.h"
#import "PhiFontDescriptiorTableViewCell.h"
#import "PhiColorTableViewCell.h"
#import "PhiChoiceTableViewController.h"

@implementation PhiFontViewController


- (id)initWithStyle:(UITableViewStyle)style tableViewCell:(PhiTableViewCell *)cell {
	if (self = [super initWithStyle:style]) {
		tableViewCell = [cell retain];
		self.title = cell.textLabel.text;
		fontDescriptor = NULL;
	}
	return self;
}

- (NSArray *)fontFamilyNames {
	if (!fontFamilyNames) {
		NSMutableSet *nameSet = [[NSMutableSet alloc] initWithCapacity:50];
		CTFontCollectionRef collection = CTFontCollectionCreateFromAvailableFonts(NULL);
		CFArrayRef fonts = CTFontCollectionCreateMatchingFontDescriptors(collection);
		
		for (CFIndex i = 0; i < CFArrayGetCount(fonts); i++) {
			CTFontDescriptorRef font = CFArrayGetValueAtIndex(fonts, i);
			CFStringRef name = CTFontDescriptorCopyAttribute(font, kCTFontFamilyNameAttribute);
			if ([(NSString *)name characterAtIndex:0] != '.')
				[nameSet addObject:(NSString *)name];
			CFRelease(name);
		}
		
		CFRelease(fonts);
		CFRelease(collection);
		fontFamilyNames = [[[nameSet allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] retain];
		[nameSet release];
	}
	return fontFamilyNames;
}

- (void)tableViewCell:(UITableViewCell *)cell valueDidChange:(id)sender forEvent:(UIEvent *)event {
	for (PhiTableViewCell *visibleCell in [self.tableView visibleCells]) {
		if (cell != visibleCell) {
			visibleCell.detailTextLabel.text = nil;
		}
	}
	[self setFontDescriptor:(CTFontDescriptorRef)[(PhiChoiceTableViewCell *)cell selectedObjectForController:sender]];

	[tableViewCell valueDidChange:self forEvent:event];
	[tableViewCell setNeedsLayout];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	[self fontFamilyNames];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		default:
			return [[self fontFamilyNames] count];
	}
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		default:
			return nil;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	PhiTableViewCell *cell = nil;
    
	switch (indexPath.section) {
		case 0:
			if (!(cell = (PhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhiFontDescriptiorTableCell"]))
				cell = (PhiTableViewCell *)[self loadCellWithIdentifier:@"PhiFontDescriptiorTableCell"];
			NSString *familyName = [[self fontFamilyNames] objectAtIndex:indexPath.row];
			NSString *currentFamilyName = nil;
			CFStringRef familyNameKey = kCTFontFamilyNameAttribute;
			CFDictionaryRef singleton = CFDictionaryCreate(NULL, (const void **)&familyNameKey, (const void **)&familyName, 1, NULL, NULL);
			CTFontDescriptorRef font = CTFontDescriptorCreateWithAttributes(singleton);
			[cell.textLabel setText:familyName];
			[(PhiFontDescriptiorTableViewCell *)cell setFontDescriptor:font];
			if (fontDescriptor) {
				currentFamilyName = (NSString *)CTFontDescriptorCopyAttribute(fontDescriptor, kCTFontFamilyNameAttribute);
			}
			if (currentFamilyName && [currentFamilyName isEqual:familyName]) {
				[[cell detailTextLabel] setText:[(PhiFontDescriptiorTableViewCell *)cell textForObject:(id)fontDescriptor]];
			} else
				[[cell detailTextLabel] setText:@""];
			if (currentFamilyName)
				CFRelease((CFStringRef)currentFamilyName);
			CFRelease(font);
			CFRelease(singleton);
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	UITableViewController *detailViewController = nil;
	
	if ([cell isKindOfClass:[PhiChoiceTableViewCell class]]) {
		detailViewController = [[PhiChoiceTableViewController alloc] initWithStyle:UITableViewStyleGrouped tableViewCell:(PhiTableViewCell *)cell];
	}
	
	if (detailViewController) {
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
	if (fontFamilyNames) {
		[fontFamilyNames release];
		fontFamilyNames = nil;
	}
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	if (fontFamilyNames) {
		[fontFamilyNames release];
		fontFamilyNames = nil;
	}
}

- (void)setFontDescriptor:(CTFontDescriptorRef)aFontDescriptor {
	if (aFontDescriptor != fontDescriptor) {
		if (fontDescriptor)
			CFRelease(fontDescriptor);
		if (aFontDescriptor) {
			fontDescriptor = CTFontDescriptorCreateCopyWithAttributes(aFontDescriptor, NULL);
			CFStringRef displayName = CTFontDescriptorCopyAttribute(fontDescriptor, kCTFontDisplayNameAttribute);
			tableViewCell.detailTextLabel.text = (NSString *)displayName;
			CFRelease(displayName);
		} else {
			fontDescriptor = NULL;
		}
	}
}
- (CTFontDescriptorRef)copyFontDescriptor {
	CTFontDescriptorRef rv = NULL;
	if (fontDescriptor) {
		rv = CTFontDescriptorCreateCopyWithAttributes(fontDescriptor, NULL);
	}
	return rv;
}

- (void)dealloc {
	if (fontFamilyNames) {
		[fontFamilyNames release];
		fontFamilyNames = nil;
	}
	if (fontDescriptor)
		CFRelease(fontDescriptor);
	fontDescriptor = NULL;

    [super dealloc];
}


@end

