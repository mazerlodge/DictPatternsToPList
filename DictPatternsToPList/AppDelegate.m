//
//  AppDelegate.m
//  DictPatternsToPList
//
//  Created by Mazerlodge on 3/1/13.
//  Copyright (c) 2013 Mazerlodge. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize workingDir;
@synthesize inFile;
@synthesize outFile;
@synthesize msg;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    msg.stringValue = @"Select a file to port";
    [self loadFormFieldsFromPlist];
    
}

- (NSData*)readDataFromFileAtPath:(NSString *)filename {
    
    //NSLog(@"Reading from: %@", filename);
    
    NSFileHandle* aHandle = [NSFileHandle fileHandleForReadingAtPath:filename];
    NSData* fileContents = nil;
    
    if (aHandle)
        fileContents = [aHandle readDataToEndOfFile];
    else
        NSLog(@"WARNING: File handle was nil");
    
    return fileContents;

}

- (void) loadFormFieldsFromPlist {
    // Read the form fields used in a previous run so the user doesn't have to
    //  type them.
    
    // NOTE: V2 Enhancement, get this from the current user's library
    NSArray *fields = [[NSArray alloc] initWithContentsOfFile:@"/tmp/DictionaryPatternsToPList.plist"];

    if ([fields count] >=3) {
        workingDir.stringValue = [fields objectAtIndex:0];
        inFile.stringValue = [fields objectAtIndex:1];
        outFile.stringValue = [fields objectAtIndex:2];
        
    }
    
}

- (void) saveFormFieldsToPList {
    // Write the form fields to a PList so the user doesn't have to retype them
    //   next time.
    
    NSMutableArray *fields = [[NSMutableArray alloc] initWithCapacity:3];
    
    [fields addObject:workingDir.stringValue];
    [fields addObject:inFile.stringValue];
    [fields addObject:outFile.stringValue];
    
    // NOTE: V2 Enhancement, store this is the current user's library
    //       It seems the directory must exist before attempting to write the file.
    //NSString *settingsFile = [@"~/Library/SPSW/DictPatternsToPList/DictPatternsToPList.plist" stringByExpandingTildeInPath];
    //NSLog(@"%@",settingsFile);
    
    // For now use the tmp folder.
    [fields writeToFile:@"/tmp/DictionaryPatternsToPlist.plist" atomically:YES];
    //[fields writeToFile:settingsFile atomically:YES];
    
}

- (IBAction)go:(id)sender {

    // Verify infile and outfile are set to something
    if (([inFile.stringValue length] == 0)
        || ([outFile.stringValue length] == 0)) {
        // Set message
        msg.stringValue = @"Please specify in and out files first.";
        return;
    }
    
    // Save field values for subsequent use
    [self saveFormFieldsToPList];
    
    // Construct a full path to the input and output files
    NSString *expandedPath = [workingDir.stringValue stringByExpandingTildeInPath];
    NSMutableString *inFP = [[NSMutableString alloc] initWithFormat:@"%@", expandedPath];
    NSMutableString *outFP = [[NSMutableString alloc] initWithFormat:@"%@", expandedPath];
    [inFP appendFormat:@"/%@",inFile.stringValue];
    [outFP appendFormat:@"/%@", outFile.stringValue];

    // Get a list of lines from the input file
    NSMutableArray *patternList = [self getLinesFromFile:inFP];
    NSString *lineCountMsg = [[NSString alloc] initWithFormat:@"Got %ld entries.",
                                        (unsigned long)[patternList count]];
    msg.stringValue = lineCountMsg;

    // TODO: Output the CSV lines to a PList
    // Note: Potential V2, load these lines into a DictPattern Object and output that.
    [patternList writeToFile:outFP atomically:YES];
    
}

- (NSMutableArray *) getLinesFromFile: (NSString *) filename {
    
    NSMutableArray *rval = [[NSMutableArray alloc] initWithCapacity:80];

    // Read the infile
    NSData *inData = [self readDataFromFileAtPath:filename];
    NSUInteger totalBytes = [inData length];
    msg.stringValue = [[NSString alloc] initWithFormat:@"Got %ld bytes",totalBytes];
    
    // Prep buffer and range for parsing data
    Byte EOL_MARKER = 0x0a; // Newline \n
    Byte EOF_MARKER = 0x00; // EOF nulls
    int BUFF_SIZE = (totalBytes < 80) ? (int)totalBytes : 80;
    
    Byte buff[80]; // setting size dynamically (using BUFF_SIZE) gives zero size

    NSRange readRange;
    readRange.location = 0;
    readRange.length = BUFF_SIZE;

    int endPos = 0;
    NSUInteger bytesRead = 0;
    while (bytesRead < totalBytes) {
        // Clean the buffer
        for (int idx=0; idx<80; idx++)
            buff[idx] = 0;

        // Read the first chunk
        [inData getBytes:buff range:readRange];
        
        // Find the EOL or EOF marker
        for (int idx=0; idx<BUFF_SIZE; idx++) {
            if ((buff[idx] == EOL_MARKER)
                || (buff[idx] == EOF_MARKER)) {
                endPos = idx;
                break;
            }
        }
        
        // Copy the line chunk into a NSString
        NSString *currentLine = [[NSString alloc] initWithBytes:buff
                                                         length:endPos
                                                       encoding:NSASCIIStringEncoding];

        // Add the string to the return array
        [rval addObject:currentLine];
        
        // Update the byte count and range to be read next
        bytesRead += endPos + 1; // add 1 for EOL marker
        readRange.location += endPos + 1;
        
        // If readRange would overrun file, trim the length back
        if ((readRange.location + readRange.length) > totalBytes)
            readRange.length = totalBytes - readRange.location;
        
    }
    
    return rval;
    
}

@end
