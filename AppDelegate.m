//
//  AppDelegate.m
//  CIS X VIEW
//
//  Created by Fantine on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate
/*
- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    id doc = [dc openDocumentWithContentsOfFile:filename display:YES];
    
    return ( doc != nil);
}
*/
- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    return NO;
}


@end
