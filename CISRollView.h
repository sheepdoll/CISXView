//
//  CISRollView.h
//  CisXView
//
//  Created by Fantine on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCZoomView.h"


@interface CISRollView : GCZoomView
{

	IBOutlet NSProgressIndicator *fileLoadProgress;


	NSMutableArray *displayCISLines;
	
		// in the file these are little endian, so we can not cast to a struct
	UInt16 scannerWidth;
	UInt16 scannerReserved1;
	UInt16 scannerTempo;
	UInt16 scannerLPI;
	UInt32 scannerLineCount;

}



- (NSArray *)displayCISLines;

- (void)displayCISLinesFromData:(NSData *)rawCISData;


- (unsigned)countOfDisplayCISLines;
- (id)objectInDisplayCISLinesAtIndex:(unsigned)theIndex;
- (void)getDisplayCISLines:(id *)objsPtr range:(NSRange)range;
- (void)insertObject:(id)obj inDisplayCISLinesAtIndex:(unsigned)theIndex;
- (void)removeObjectFromDisplayCISLinesAtIndex:(unsigned)theIndex;
- (void)replaceObjectInDisplayCISLinesAtIndex:(unsigned)theIndex withObject:(id)obj;

- (void)awakeFromNib;
- (BOOL)acceptsFirstResponder;
- (void)drawRect:(NSRect)aRect;

@end