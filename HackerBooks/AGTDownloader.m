//
//  AGTDownloader.m
//  HackerBooks
//
//  Created by Fernando on 4/5/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import "AGTDownloader.h"

@implementation AGTDownloader

+(NSURL*) urlInDocumentsFromThisFile:(NSString*) file {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* urlsDocumentDirectory = [fileManager URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask];
    NSURL* urlDocument = [urlsDocumentDirectory lastObject];
    return [urlDocument URLByAppendingPathComponent:file];
}


+(void) readAndSaveDataFromURL:(NSURL*) url  andSaveWithName:(NSString*) fileName handleError:(void (^)(NSError* error)) handleError {
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   handleError(error);
                                   return;
                               }
                               [AGTDownloader saveData:data whitFile:fileName];
                           }];
}


+(void) saveData:(NSData*) data  whitFile:(NSString*) fileName {
    NSURL* urlFullPathJsonData = [AGTDownloader urlInDocumentsFromThisFile:fileName];
    [data writeToURL:urlFullPathJsonData atomically:YES];
}

+(BOOL) isHasDownloadedFileFromName:(NSString*) fileName {
    NSURL* urlFullPathJsonData = [AGTDownloader urlInDocumentsFromThisFile:fileName];
    return [urlFullPathJsonData checkResourceIsReachableAndReturnError:nil];
}

+(NSData*) getDataFromLocalDocumentsWithName:(NSString*) fileName {
    NSURL* fileURL = [AGTDownloader urlInDocumentsFromThisFile:fileName];
    return [NSData dataWithContentsOfURL:fileURL];
}

@end
