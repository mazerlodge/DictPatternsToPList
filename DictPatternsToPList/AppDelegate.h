//
//  AppDelegate.h
//  DictPatternsToPList
//
//  Created by Mazerlodge on 3/1/13.
//  Copyright (c) 2013 Mazerlodge. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
    NSTextField *workingDir;
    NSTextField *inFile;  // a CSV filename
    NSTextField *outFile; // a PList filename
    NSTextField *msg;     // a text label for status output

}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSTextField *workingDir;
@property (nonatomic, retain) IBOutlet NSTextField *inFile;
@property (nonatomic, retain) IBOutlet NSTextField *outFile;
@property (nonatomic, retain) IBOutlet NSTextField *msg;

- (IBAction)go:(id)sender;

@end
