//
//  MyDocument.h
//  CisXView
//
//  Created by Fantine on 2/27/11.
//  Copyright __MyCompanyName__ 2011 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "CISRollView.h"

@interface MyDocument : NSDocument
{

	IBOutlet CISRollView *cisView;
	

	NSData *cisRawData;
}
@end
