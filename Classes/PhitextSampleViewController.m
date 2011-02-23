//
//  PhitextSampleViewController.m
//  PhitextSample//
//  Created by Corin Lawson on 4/02/10.
//  Copyright Corin Lawson 2010. All rights reserved.
//

#define PHI 1.61803398874989484820458683436563812

//#define SAMPLE_FILE @"sample"

#import "PhitextSampleViewController.h"

@implementation PhitextSampleViewController


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	//NSLog(@"In [PhitextSampleViewController scrollViewWillBeginDragging:]");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate  {
	//NSLog(@"In [PhitextSampleViewController scrollViewDidEndDragging:willDecelerate:]");
}
- (void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
	//NSLog(@"In [PhitextSampleViewController scrollViewDidScrollToTop:]");
}
- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
	return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	//NSLog(@"In [PhitextSampleViewController scrollViewDidScroll:]");
}

- (void)textViewDidChange:(PhiTextEditorView *)textView {
	//NSLog(@"In [PhitextSampleViewController textViewDidChange]");
}


- (void)viewDidLoad {
    [super viewDidLoad];

	//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//[defaults addSuiteNamed:@"com.phitext"];

	//[defaults setBool:YES forKey:@"displayDottedThirds"];
	//[defaults setFloat:1.0f forKey:@"lineThickness"];
	//[defaults setFloat:PHI forKey:@"magnification"];

#ifdef SAMPLE_FILE
	CTParagraphStyleSetting setting;
	CGFloat paraSpacing = 18;
	CTFontRef font = CTFontCreateWithName((CFStringRef)@"Helvetica", 17.4, NULL);
	NSString *filePath = [[NSBundle mainBundle] pathForResource:SAMPLE_FILE ofType:@"txt"];
	
	setting.spec = kCTParagraphStyleSpecifierParagraphSpacing;
	setting.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
	setting.valueSize = sizeof(CGFloat);
	setting.value = &paraSpacing;

	CFStringRef keys[] = {
		kCTParagraphStyleAttributeName,
		kCTFontAttributeName,
		kCTForegroundColorAttributeName
	};
	CFTypeRef values[] = {
		CTParagraphStyleCreate(&setting, 1),
		font,
		[[UIColor blackColor] CGColor]
	};
	CFDictionaryRef attr = CFDictionaryCreate(NULL, (void *)keys, (void *)values, 2,
											  &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	
	NSMutableAttributedString *textStore = [[[NSMutableAttributedString alloc] initWithString:[NSString stringWithContentsOfFile:filePath encoding:NSMacOSRomanStringEncoding error:NULL]
																				   attributes:(NSDictionary *)attr] autorelease];
	CFRelease(attr);
	CFRelease(font);
#else
	NSMutableAttributedString *textStore = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:nil] autorelease];
#endif
	
	editor = (PhiTextEditorView *)[self.view retain];
	editor.delegate = self;
	editor.autocapitalizationType = UITextAutocapitalizationTypeSentences;
	//editor.autocorrectionType = UITextAutocorrectionTypeNo;
	editor.textDocument.store.attributedString = textStore;
	[editor addCustomMenuItem:[[[UIMenuItem alloc] initWithTitle:@"Copy Style" action:@selector(copyStyle:)] autorelease] atPage:0];
	[editor addCustomMenuItem:[[[UIMenuItem alloc] initWithTitle:@"Edit Style" action:@selector(showStylePopover)] autorelease] atPage:0];
	[editor addCustomMenuItem:[[[UIMenuItem alloc] initWithTitle:@"Paste Style" action:@selector(pasteStyle:)] autorelease] atPage:0];
	
//	font = CTFontCreateWithName((CFStringRef)@"Courier New", 14.0, NULL);
//	[editor.textDocument.store addAttribute:kCTFontAttributeName value:font range:NSMakeRange(605, 209)];
//	CFRelease(font);
	
//	self.view = [[UIView alloc] initWithFrame:editor.bounds];
//	[self.view addSubview:editor];
	
//	editor.textDocument.wrap = NO;
/*
	CGSize textSize = CGSizeMake(editor.textDocument.wrap?[[UIScreen mainScreen] applicationFrame].size.width:CGFLOAT_MAX, CGFLOAT_MAX);
	//The following method call is very expensive for large files, avoid using it.
	//Alternatively you may like to estimate the size of the view from the length
	// of the text or determine the size at some other time and store/cache it.
	textSize = [[editor textDocument] suggestTextSize];
	textSize.height = MAX(textSize.height, 1004); // and make it at least as big as the screen
	textSize.width = [[UIScreen mainScreen] applicationFrame].size.width; // fix it regardless of suggested size
    editor.contentSize = textSize;
*/	
	//[editor performSelector:@selector(scrollRangeToVisible:) withObject:[PhiTextRange textRangeWithRange:NSMakeRange(1580, 21)] afterDelay:1.0];

	//[NSThread detachNewThreadSelector:@selector(twiddle:) toTarget:self withObject:NULL];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
#if DEBUG_TILE_HINTS
	if (!pinchGesture) {
		pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	}
	[self.view addGestureRecognizer:pinchGesture];
#endif
}

- (void)viewDidUnload {
#if DEBUG_TILE_HINTS
	if (pinchGesture) {
		[self.view removeGestureRecognizer:pinchGesture];
		[pinchGesture release];
	}
	pinchGesture = nil;
#endif
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[editor release];
	editor = nil;
	
	[self viewDidUnload];
}

#if DEBUG_TILE_HINTS
- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
	if ([pinch numberOfTouches] > 1) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults addSuiteNamed:@"com.phitext"];
		
		if (pinch.state == UIGestureRecognizerStateBegan) {
			CGPoint a = [pinch locationOfTouch:0 inView:nil];
			CGPoint b = [pinch locationOfTouch:1 inView:nil];
			CGFloat x = a.x - b.x;
			CGFloat y = a.y - b.y;
			
			if (signbit(x) == signbit(y)) {
				pinchingTextFrameTile = YES;
				originalHeight = [defaults floatForKey:@"frameTileHeightHint"];
			} else {
				pinchingTextFrameTile = NO;
				originalHeight = [defaults floatForKey:@"tileHeightHint"];
			}
		} else {
			if (pinchingTextFrameTile) {
				[defaults setFloat:originalHeight * pinch.scale forKey:@"frameTileHeightHint"];
			} else {
				[defaults setFloat:originalHeight * pinch.scale forKey:@"tileHeightHint"];
			}
		}
		[[editor textDocument] invalidateDocument];
		[editor setNeedsDisplay];
	}
}
#endif

- (void)setColor:(UIColor *)color {
	[editor.textDocument.store addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[color CGColor] range:[editor clampRange:NSMakeRange(49, 10)]];
}
- (void)clearColor {
	[editor.textDocument.store removeAttribute:(NSString *)kCTForegroundColorAttributeName range:[editor clampRange:NSMakeRange(49, 10)]];
}
- (BOOL)stopTwiddle {
	return NO;
}
- (void)twiddle:(id)context
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[NSThread sleepForTimeInterval:100];
	while(![self stopTwiddle])
	{
		[self setColor:[UIColor redColor]];
		[NSThread sleepForTimeInterval:100];
		[self clearColor];
		[NSThread sleepForTimeInterval:100];
	}
	[pool drain];
	[pool release];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	NSTimeInterval animationDuration;
	editorFrame = editor.frame;
	CGRect intersection, keyboardFrame, newTextEditorFrame = editorFrame;
	CGSize docSize = CGSizeZero;
	
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
	keyboardFrame = [editor.superview convertRect:keyboardFrame fromView:nil];
	intersection = CGRectIntersection(editorFrame, keyboardFrame);
	
	if (intersection.size.height * intersection.size.width != 0.0f) {
		if (keyboardFrame.size.width < keyboardFrame.size.height) {
			if (!keyboardFrame.origin.x)
				newTextEditorFrame.origin.x = intersection.size.width;
			newTextEditorFrame.size.width -= intersection.size.width;
			docSize.width = newTextEditorFrame.size.height;
		} else {
			if (!keyboardFrame.origin.y)
				newTextEditorFrame.origin.y = intersection.size.height;
			newTextEditorFrame.size.height -= intersection.size.height;
			docSize.width = newTextEditorFrame.size.width;
		}
		docSize.height = editor.textDocument.size.height;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:animationDuration];
		[UIView setAnimationDidStopSelector:@selector(scrollSelectionToVisible)];
		[UIView setAnimationDelegate:editor];
		[editor setFrame:newTextEditorFrame];
		//[editor.textDocument setSize:docSize];
		[UIView commitAnimations];
	}
	//[self changeBackgroundToRandomColor];
}
- (IBAction)changeBackgroundToRandomColor {
	CGFloat colorComponents[3];
	colorComponents[0] = (CGFloat) rand() / RAND_MAX;
	colorComponents[1] = (CGFloat) rand() / RAND_MAX;
	colorComponents[2] = 2.0 - colorComponents[0] - colorComponents[1];
	editor.backgroundColor = [UIColor colorWithRed:colorComponents[0] green:colorComponents[1] blue:colorComponents[2] alpha:1.0];
}
- (void)keyboardWillHide:(NSNotification *)notification {
	NSTimeInterval animationDuration;
	
	[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [editor setFrame:editorFrame];
    [UIView commitAnimations];
}

- (void)scrollToVisibleRect:(NSValue *)rect {
	[editor scrollRectToVisible:[rect CGRectValue] animated:YES];
}	
	 
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}

@end
