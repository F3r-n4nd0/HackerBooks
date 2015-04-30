//
//  AGTDownloader.h
//  HackerBooks
//
//  Created by Fernando on 4/5/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGTDownloader : NSObject

+(NSURL*) urlInDocumentsFromThisFile:(NSString*) file;
+(void) readAndSaveDataFromURL:(NSURL*) url  andSaveWithName:(NSString*) fileName handleError:(void (^)(NSError* error)) handleError confirmationUpdate:(void(^)()) confirmationUpdate;
+(void) saveData:(NSData*) data  whitFile:(NSString*) fileName;
+(BOOL) isHasDownloadedFileFromName:(NSString*) fileName;
+(NSData*) getDataFromLocalDocumentsWithName:(NSString*) fileName;
+(BOOL) isDownloadingDataFromUrl:(NSURL*) url;
@end
