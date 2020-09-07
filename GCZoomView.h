//
//  GCZoomView.h
//  DrawingArchitecture
//
//  Created by graham on 13/09/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GCZoomView : NSView
{
	float				_scale;					// the zoom scale of the view (1.0 = 100%)
}

- (IBAction)			zoomIn: (id) sender;
- (IBAction)			zoomOut: (id) sender;
- (IBAction)			zoomToActualSize: (id) sender;
- (IBAction)			zoomFitInWindow: (id) sender;

- (void)				zoomViewByFactor: (float) factor;
- (void)				zoomViewToAbsoluteScale: (float) scale;
- (void)				zoomViewToFitRect: (NSRect) aRect;
- (void)				zoomViewToRect: (NSRect) aRect;
- (void)				zoomViewByFactor: (float) factor andCentrePoint:(NSPoint) p;
- (void)				zoomWithScrollWheelDelta: (float) delta toCentrePoint:(NSPoint) cp;

- (NSPoint)				centredPointInDocView;
- (void)				scrollPointToCentre:(NSPoint) aPoint;

- (float)				scale;
- (float)				minimumScale;
- (float)				maximumScale;

@end


extern NSString*	kGCDrawingViewDidChangeScale;


/*
This is a very general-purpose view class that provides some handy high-level methods for doing zooming. Simply hook up
the action methods to suitable menu commands and away you go. The stuff you draw within drawRect: doesn't need to know or
care abut the zoom of the view - you can just draw as usual and it works.

NOTE: this class doesn't bother to support NSCding and thereby encoding the view zoom, because it usually isn't important for this
value to persist. However, if your subclass wants to support coding, your initWithCoder method should reset _scale to 1.0. Otherwise
it will get initialized to 0.0 and N0THING WILL BE DRAWN.

*/
