//
//  PhiFontDescriptiorTableViewCell.m
//  Untitled
//
//  Created by Corin Lawson on 23/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiFontDescriptiorTableViewCell.h"


@implementation PhiFontDescriptiorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        fontDescriptor = NULL;
    }
    return self;
}

- (NSArray *)choices {
	if (!fontDescriptor) {
		return [NSArray array];
	}
	CFArrayRef singleton = CFArrayCreate(NULL, (const void **)&fontDescriptor, 1, NULL);
	CTFontCollectionRef collection = CTFontCollectionCreateWithFontDescriptors(singleton, NULL);
	CFArrayRef fonts = CTFontCollectionCreateMatchingFontDescriptors(collection);
	NSArray *array = [NSArray arrayWithArray:(NSArray *)fonts];
	CFRelease(fonts);
	CFRelease(collection);
	CFRelease(singleton);
	return array;
}

- (NSString *)textForObject:(id)object {
	CTFontDescriptorRef font = (CTFontDescriptorRef)object;
	NSString *parentText = self.textLabel.text;
	NSString *text = (NSString *)CTFontDescriptorCopyAttribute(font, kCTFontDisplayNameAttribute);
	[text autorelease];
	text = [text stringByReplacingOccurrencesOfString:parentText withString:@"" options:NSAnchoredSearch range:NSMakeRange(0, [parentText length])];
	text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if (![text length])
		return @"Regular";
	return text;
}

- (void)setFontDescriptor:(CTFontDescriptorRef)aFontDescriptor {
	if (aFontDescriptor != fontDescriptor) {
		if (fontDescriptor)
			CFRelease(fontDescriptor);
		if (aFontDescriptor) {
			fontDescriptor = CTFontDescriptorCreateCopyWithAttributes(aFontDescriptor, NULL);
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
	if (fontDescriptor)
		CFRelease(fontDescriptor);
	fontDescriptor = NULL;
    [super dealloc];
}


@end
