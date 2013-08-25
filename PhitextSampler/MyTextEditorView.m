//
//  MyTextEditorView.m
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

#import "MyTextEditorView.h"
#import "PhiTextStyleViewController.h"

@implementation MyTextEditorView

@synthesize popover;

- (void)layoutSubviews {
	[self.textDocument setSize:CGSizeMake(self.bounds.size.width, self.textDocument.size.height)];

	[super layoutSubviews];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	if (action == @selector(pasteStyle:) && !pasteStyle)
		return NO;

	return [super canPerformAction:action withSender:sender];
}

- (void)_updateNavigationItem {
	if (self.popover) {
		UINavigationItem *navItem = [[(UINavigationController *)self.popover.contentViewController topViewController] navigationItem];
		if (pasteStyle && ![navItem rightBarButtonItem]) {
			UIBarButtonItem *pasteButton = [[UIBarButtonItem alloc] initWithTitle:@"Paste" style:UIBarButtonItemStyleDone target:self action:@selector(pasteStyle:)];
			navItem.rightBarButtonItem = pasteButton;
			[pasteButton release];
		} else if (!pasteStyle && [navItem rightBarButtonItem]) {
			navItem.rightBarButtonItem = nil;
		}
	}
}

-(void)pasteStyle:(id)sender {
	[self hideMenu];
	[self.popover dismissPopoverAnimated:YES];
	if (pasteStyle)
		[self setTextStyleForSelectedRange:pasteStyle];
}
-(void)copyStyle:(id)sender {
	[self hideMenu];
	
	[pasteStyle release];
	if (self.popover.popoverVisible)
		pasteStyle = [[(PhiTextStyleViewController *)[[(UINavigationController *)self.popover.contentViewController viewControllers] objectAtIndex:0]
					   textStyle] copy];
	else
		pasteStyle = [[self textStyleForSelectedRange] copy];
	
	[self _updateNavigationItem];
}

-(void)showStylePopover {
	[self hideMenu];
	
	UINavigationController *nav = nil;
	PhiTextStyle *style = [[self textStyleForSelectedRange] copy];
	if (!self.popover) {
		PhiTextStyleViewController* content = [[PhiTextStyleViewController alloc] initWithNibName:@"PhiTextStyleViewController" bundle:nil];
		UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Text Style"];
		UIBarButtonItem *copyButton = [[UIBarButtonItem alloc] initWithTitle:@"Copy" style:UIBarButtonItemStylePlain target:self action:@selector(copyStyle:)];
		
		navItem.leftBarButtonItem = copyButton;
		[copyButton release];
		[content setNavigationItem:navItem];
		[navItem release];

		nav = [[UINavigationController alloc] initWithRootViewController:content];
		nav.contentSizeForViewInPopover = content.contentSizeForViewInPopover;
		UIPopoverController* aPopover = [[UIPopoverController alloc]
										 initWithContentViewController:nav];
		[nav release];
		
		//aPopover.delegate = self;
		[content setTextStyle:style];
		content.delegate = self;
		[content release];
		
		// Store the popover in a custom property for later use.
		self.popover = aPopover;
		[aPopover release];
	} else {
		nav = (UINavigationController *)self.popover.contentViewController;
		[nav popToRootViewControllerAnimated:NO];
		[(PhiTextStyleViewController *)[nav topViewController] setTextStyle:style];
	}
	[self _updateNavigationItem];
	[style release];
	
	CGRect targetRect = [self convertRect:self.menuTargetRect toView:nil];
	
	if (targetRect.origin.y < 460 && CGRectGetMaxY(targetRect) > 460) {
		targetRect = CGRectIntersection(targetRect, CGRectMake(0, 480, 1024, 1024));
	}
	[self.popover presentPopoverFromRect:[self convertRect:targetRect fromView:nil] inView:self
								   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)textStyle:(PhiTextStyle *)textStyle didChange:(id)sender {
	[self setTextStyleForSelectedRange:textStyle];
}

-(void)dealloc {
	[pasteStyle release];
	self.popover = nil;
	[super dealloc];
}

@end
