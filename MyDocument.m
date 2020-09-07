//
//  MyDocument.m
//  CisXView
//
//  Created by Fantine on 2/27/11.
//  Copyright __MyCompanyName__ 2011 . All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}


- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)pTypeName error:(NSError **)outError
{
	NSLog(@"URL: %@ typething: %@",[absoluteURL path],pTypeName);
	if([pTypeName isEqualToString:@"CISDataType"])
	{
//		NSString *data = [NSString stringWithContentsOfURL:absoluteURL encoding:NSMacOSRomanStringEncoding error:outError];
		NSData *rawCISHeaderStream = [NSData dataWithContentsOfURL:absoluteURL];
	
		// try segmenting file
//		NSFileHandle *rawCISFile = [NSFileHandle fileHandleForReadingAtPath:[absoluteURL path]];
//		NSData *rawCISHeaderStream = [rawCISFile readDataOfLength:40];
				
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
		if (rawCISHeaderStream==nil)
		{
			NSLog(@"Error Reading file at %@: %@", [absoluteURL path],outError);
			return NO;
		} 
		else
		{
		
			[self init];
			
			//[rawMIDIByteStream retain];
			NSLog(@"implied data length: %lu",[rawCISHeaderStream length]);
			// NSScanner? for cis files
			// characterAtIndex:
			//NSString *CISHeaderID = [rawCISHeaderStream substringToIndex:40];
			NSData *cisHeaderData = [rawCISHeaderStream subdataWithRange:NSMakeRange(0,40)];
			
			//UInt8 *pDebugBytes = (UInt8 *)[rawCISHeaderStream bytes]; 
			// pDebugBytes = (UInt8 *)[cisHeaderData bytes]; 
			
			NSString *cisHeaderText = [[[NSString alloc] initWithData:cisHeaderData encoding:NSASCIIStringEncoding] autorelease];
			NSLog(@"CIS Header text:");
			NSLog(@"%@",cisHeaderText);
			
			NSRange restOfFile = {40, [rawCISHeaderStream length]-40}; 
			cisRawData = [rawCISHeaderStream subdataWithRange:restOfFile];
				
			//UInt8 *pMIDIFileStream = (UInt8 *)[rawMIDIByteStream bytes]; 
			//standardMIDIFileFormat = pMIDIFileStream[8] << 8 | pMIDIFileStream[9];
			//UInt16 nMIDITracks  = pMIDIFileStream[10] << 8 | pMIDIFileStream[11];
			//standardMIDIFileDivision = pMIDIFileStream[12] << 8 | pMIDIFileStream[13];
			//NSLog(@" MThd %d %d %d (0x%x)", standardMIDIFileFormat,nMIDITracks,standardMIDIFileDivision,standardMIDIFileDivision);
			return YES;
		}
	} else {
		return [super readFromURL:absoluteURL ofType:pTypeName error:outError];
	}
}


- (void) awakeFromNib
{
	NSLog(@"myDoc awake from nib ");

	

	if(cisView)
	{
		NSLog(@"we have a view");
		
		// simply send the rest of the data to the view class to finish parsing
		// and set the window from

		[(CISRollView *)cisView displayCISLinesFromData:cisRawData];

	}
	else
	{
		NSLog(@"** ERROR -- unable to set view class frame and Data Model");
	}


}



@end
