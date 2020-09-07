//
//  CISRollView.m
//  CisXView
//
//  Created by Fantine on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CISRollView.h"


@implementation CISRollView

- (NSArray *)displayCISLines {
    if (!displayCISLines) {
        displayCISLines = [[NSMutableArray alloc] init];
    }
    return [[displayCISLines retain] autorelease];
}



- (void)displayCISLinesFromData:(NSData *)rawCISData
//	height:(CGFloat) width:(CGFloat) resoluton:(UInt16)
{
	// locate or create a new line array object
	if (!displayCISLines)
	{
		displayCISLines = [[[NSMutableArray alloc] init] retain];
	}
	 
	// the format of the CIS file is simple after the header there
	// is simply an array of array of ints  the sum which should add up 
	// to the width.
	//UInt8 *pDebugBytes = (UInt8 *)[rawCISHeaderStream bytes]; 
	UInt16 *pCISDataStream = (UInt16 *)[rawCISData bytes]; 
    
    BOOL dualArray = NO;
    UInt16 changeover = 0;
    UInt16 oldWidth = 0;
	
	// in the file these are little endian, so we can not cast to a struct
	// use a simple stream parser with endian caster to read th rest of the header
	
	scannerWidth = EndianU16_LtoN(*pCISDataStream++);
	scannerReserved1 = EndianU16_LtoN(*pCISDataStream++);
	scannerTempo = EndianU16_LtoN(*pCISDataStream++);
	scannerLPI = EndianU16_LtoN(*pCISDataStream++);
	
	// one of the parameters is 32 bits, typecast to get it
	scannerLineCount = EndianU32_LtoN(*((UInt32 *)pCISDataStream));

	// point the stream scanner at the start of the data array
	pCISDataStream = &pCISDataStream[2];

	NSLog(@"Numeric header parameters");
	NSLog(@"Scanner Width: %u",scannerWidth);
	NSLog(@"Reserved word: %u",scannerReserved1);
  	NSLog(@"Start tempo: %u",scannerTempo);
    NSLog(@"Scanner LPI (used as resolution): %u",scannerLPI);
      
	NSLog(@"Number of lines in file: %u",scannerLineCount);
    
    // Horiz resolution
    // scanner type
    // encoder
    
    if (scannerReserved1 != 0) {
        // we are probably a dual width scanner
        changeover = scannerReserved1;
        oldWidth = scannerWidth;
        
        dualArray = YES;
        
        scannerWidth *=2;
        
        // need to locate the remaining dual header defs
        NSLog(@"DualArray parameters");
        NSLog(@"Scanner Width: %u",scannerWidth);
        //NSLog(@"ArraySep: %u",ArraySeparation);
        NSLog(@"Changeover: %u",changeover);
        //NSLog(@"NORM/REV: %u",scannerTempo);
        //NSLog(@"Mono/Bi Leval %u",scannerLPI);

    }
	
	// now we have enough information to set the frame of our window
	NSRect tempRect=NSMakeRect(0.0, 0.0,scannerWidth ,scannerLineCount); 
//	[self setBounds:tempRect];
	[self setFrame:tempRect];
	//[self setContentMaxSize:NSMakeSize(scannerWidth, 2048.0)];
	
	// set rulers and other display marks if needed
	
	// file load gets a bit slow on files over 20 megabytes

	[[fileLoadProgress window] center];
	[[fileLoadProgress window] makeKeyAndOrderFront:nil];
	[[fileLoadProgress window] display];
	[fileLoadProgress setIndeterminate:NO];
	
	// progress should bump in fixed increments  set to go from zero to 100%
	// 20 increments is probaby good at 5 percent
	UInt32 incrementProgressAfter = scannerLineCount / 20;
	UInt32 percentProgress = 0;	// this counts from 0 to incrementProgressAfter
	double progressPercent = 5.0; // this counts from 0 to 100 in steps of percent

	BOOL warnOnce = YES;
	
	// parse the rest of the stream
	UInt32 lineCount = 0;
	
	while(lineCount < scannerLineCount)
	{
		UInt16 thisCount = EndianU16_LtoN(*pCISDataStream++);

		NSMutableArray *pLineBuf = [[[NSMutableArray alloc] init] autorelease];
	
		while(thisCount < scannerWidth)
		{
			[pLineBuf addObject:[NSNumber numberWithUnsignedInt:thisCount]];
			thisCount += EndianU16_LtoN(*pCISDataStream++);
		}
        [pLineBuf addObject:[NSNumber numberWithUnsignedInt:thisCount]];

		// add a line to the display array
		[displayCISLines addObject:pLineBuf]; 
		// check for overflow
		if((thisCount > scannerWidth) && warnOnce)
		{
			// our files are large, warn only once to avoid filling the log
			// with useless data
			NSLog(@"WARNING ** scanner line overflow line number %u",lineCount);
			NSLog(@"Expected: %u counted: %u",scannerWidth,thisCount);
			warnOnce = NO;
		}
		// ignore the flag word for now.  This could be retained in a separate
		// flag track array for checking or setting the sync of files capured with
		// a sync or time track
		//Uint16 flagWord = 
		//EndianU16_LtoN(*
        pCISDataStream++;
        //);
		
		if(percentProgress++ > incrementProgressAfter)
		{
			progressPercent += 5.0;
			percentProgress = 0;
			[fileLoadProgress setDoubleValue:progressPercent];
			[fileLoadProgress displayIfNeeded];
		}
	
		lineCount++;
	}
	
	[[fileLoadProgress window] orderOut:nil];
	
	NSLog(@"total lines processed:%u",lineCount);
	// check for corrupt file
	if(lineCount != scannerLineCount)
		NSLog(@"WARNING ** Header count does not match lines in file: %u",lineCount);


}

- (unsigned)countOfDisplayCISLines {
    if (!displayCISLines) {
        displayCISLines = [[NSMutableArray alloc] init];
    }
    return [displayCISLines count];
}

- (id)objectInDisplayCISLinesAtIndex:(unsigned)theIndex {
    if (!displayCISLines) {
        displayCISLines = [[NSMutableArray alloc] init];
    }
    return [displayCISLines objectAtIndex:theIndex];
}

- (void)getDisplayCISLines:(id *)objsPtr range:(NSRange)range {
    if (!displayCISLines) {
        displayCISLines = [[NSMutableArray alloc] init];
    }
    [displayCISLines getObjects:objsPtr range:range];
}

- (void)insertObject:(id)obj inDisplayCISLinesAtIndex:(unsigned)theIndex {
    if (!displayCISLines) {
        displayCISLines = [[NSMutableArray alloc] init];
    }
    [displayCISLines insertObject:obj atIndex:theIndex];
}

- (void)removeObjectFromDisplayCISLinesAtIndex:(unsigned)theIndex {
    if (!displayCISLines) {
        displayCISLines = [[NSMutableArray alloc] init];
    }
    [displayCISLines removeObjectAtIndex:theIndex];
}

- (void)replaceObjectInDisplayCISLinesAtIndex:(unsigned)theIndex withObject:(id)obj {
    if (!displayCISLines) {
        displayCISLines = [[NSMutableArray alloc] init];
    }
    [displayCISLines replaceObjectAtIndex:theIndex withObject:obj];
}




- (void)awakeFromNib
{
	NSLog(@"CIS Roll View awake from NiB -");
	// there is not much we can do here until the document does an awakefromnib first
	
	return;
}


- (BOOL)acceptsFirstResponder
{
    return YES;
}



- (void)drawRect:(NSRect)aRect
{

	[[NSColor whiteColor] set];
	NSRectFill(aRect);

//	NSLog(@"time to draw rect %f %f ",aRect.origin.y,aRect.size.height);
//	NSLog(@"time to draw rect %f %f ",aRect.origin.x,aRect.size.width);
	UInt32 startLine = aRect.origin.y;
	UInt32 endLine = startLine + aRect.size.height;

	[[NSColor blackColor] set];
	[NSBezierPath setDefaultLineWidth:([self scale] > 1)?[self scale]*2.5:2.5];
	NSBezierPath *rollMarks = [NSBezierPath bezierPath];

	
	NSArray *lineObject;
	
	// draw oversize a bit since the scale code seems to miss some lines when mouse scrolling
	for(UInt32 lineObjectIndex = startLine; lineObjectIndex <= endLine+2;lineObjectIndex++)
	{
		if(lineObjectIndex >= [displayCISLines count])
			break;
		lineObject = [displayCISLines objectAtIndex:lineObjectIndex];
		
		NSEnumerator *enumerator = [lineObject objectEnumerator];
		NSNumber  *runLine , *runSpace;
		
		[rollMarks moveToPoint:NSMakePoint(0,lineObjectIndex)];
		
		while((runLine = [enumerator nextObject]))
		{
			[rollMarks lineToPoint:NSMakePoint( [runLine floatValue ] , lineObjectIndex)];
			runSpace = [enumerator nextObject];
			if(!runSpace)
				break;
			[rollMarks moveToPoint:NSMakePoint( [runSpace floatValue ] , lineObjectIndex)];
		}
	}
	[rollMarks stroke];
}

// over ride the zoom class
- (float)				minimumScale
{
	return 0.01;
}

- (float)				maximumScale
{
	return 15.0;
}


- (void) dealloc
{
	NSLog(@"de-allocating array memory.");

	
	NSEnumerator *lineEnumerator = [displayCISLines objectEnumerator];
	id releaseLine;
	while(releaseLine = [lineEnumerator nextObject])
	{
		[releaseLine removeAllObjects];
	}
	[displayCISLines removeAllObjects];
	[displayCISLines release];
	displayCISLines = nil;
	[super dealloc];
}


@end
