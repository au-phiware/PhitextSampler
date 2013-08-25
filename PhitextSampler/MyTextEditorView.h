//
//  MyTextEditorView.h
//  Phitext
//
//  Created by Corin Lawson on 14/09/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Phitext/Phitext.h>

@interface MyTextEditorView : PhiTextEditorView {
	UIPopoverController *popover;
	PhiTextStyle *pasteStyle;
}

@property (retain) UIPopoverController *popover;

@end
