//
//  PhiSliderTableViewCell.h
//  Untitled
//
//  Created by Corin Lawson on 20/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhiTableViewCell.h"

@interface PhiSliderTableViewCell : PhiTableViewCell {
	UISlider *slider;
	NSString *valueFormat;
}

@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, copy) NSString *valueFormat;

@end
