//
//  PhitextSampleViewController.h
//  PhitextSample
//  Created by Corin Lawson on 4/02/10.
//  Copyright Corin Lawson 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Phitext/Phitext.h>

#ifndef DEBUG_TILE_HINTS
#define DEBUG_TILE_HINTS 0
#endif

@interface PhitextSamplerViewController : UIViewController <PhiTextViewDelegate> {
	PhiTextEditorView *editor;
	CGRect editorFrame;
#if DEBUG_TILE_HINTS
	UIPinchGestureRecognizer *pinchGesture;
	BOOL pinchingTextFrameTile;
	CGFloat originalHeight;
#endif
}

- (IBAction)changeBackgroundToRandomColor;

@end

