//
//  PhiFontDescriptiorTableViewCell.h
//  Untitled
//
//  Created by Corin Lawson on 23/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "PhiChoiceTableViewCell.h"

@interface PhiFontDescriptiorTableViewCell : PhiChoiceTableViewCell {
	CTFontDescriptorRef fontDescriptor;
}

@property (nonatomic, copy, readonly) NSArray *choices;

- (void)setFontDescriptor:(CTFontDescriptorRef)aFontDescriptor;
- (CTFontDescriptorRef)copyFontDescriptor;

@end
