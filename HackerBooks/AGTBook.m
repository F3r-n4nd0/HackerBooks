//
//  AGTBook.m
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

@import UIKit;

#import "AGTBook.h"
#import "AGTDownloader.h"
#import "Settings.h"


@interface AGTBook () 
@property (nonatomic) BOOL isFavorite;
@end


@implementation AGTBook

+ (id)initWithDictionary:(NSDictionary*)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [self init];
    if (self)
    {
        if (![self isNullObject:[dictionary objectForKey:@"title"]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        if (![self isNullObject:[dictionary objectForKey:@"authors"]]) {
            NSString* stringAuthors = [dictionary objectForKey:@"authors"];
            self.authors = [stringAuthors componentsSeparatedByString:@","];
        }
        if (![self isNullObject:[dictionary objectForKey:@"tags"]]) {
            NSString* stringTags = [dictionary objectForKey:@"tags"];
            self.tags = [self trimWhitespaceFromArray:[stringTags componentsSeparatedByString:@","]];
        }
        if (![self isNullObject:[dictionary objectForKey:@"image_url"]]) {
            self.urlImage = [NSURL URLWithString:[dictionary objectForKey:@"image_url"]];
        }
        if (![self isNullObject:[dictionary objectForKey:@"pdf_url"]]) {
            self.urlPDF = [NSURL URLWithString:[dictionary objectForKey:@"pdf_url"]];
        }
    }
    return self;
}


-(BOOL)hasTag:(NSString *)tag {
    return [self.tags containsObject:tag];
}

- (UIImage*) getimageOrDownload {
    NSString* fileName = [self getFileNameFromURL:self.urlImage];
    if([AGTDownloader isHasDownloadedFileFromName:fileName]){
        NSData* dataImage = [AGTDownloader getDataFromLocalDocumentsWithName:fileName];
        return [UIImage imageWithData:dataImage];
    }
    [AGTDownloader readAndSaveDataFromURL:self.urlImage andSaveWithName:fileName handleError:nil confirmationUpdate:nil];
    return nil;
}

- (NSString*) downloadPdf {
    NSString* fileName = [self getFileNameFromURL:self.urlPDF];
    if([AGTDownloader isHasDownloadedFileFromName:fileName]){
        return [AGTDownloader urlInDocumentsFromThisFile:fileName].path;
    }
    [AGTDownloader readAndSaveDataFromURL:self.urlPDF andSaveWithName:fileName handleError:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FINISH_DOWNLOAD_BOOK object:self];
    } confirmationUpdate:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FINISH_DOWNLOAD_BOOK object:self];
    }];
    return nil;
}


-(BOOL) isPdfDownloaded {
    NSString* fileName = [self getFileNameFromURL:self.urlPDF];
    return [AGTDownloader isHasDownloadedFileFromName:fileName];
}

-(BOOL) isDownloadingPdf {
    return [AGTDownloader isDownloadingDataFromUrl:self.urlPDF];
}

#pragma mark - Helper 


-(NSArray*) trimWhitespaceFromArray:(NSArray*) array {
    NSMutableArray *trimmedStrings = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *string in array) {
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [trimmedStrings addObject:trimmedString];
    }
    return [trimmedStrings  copy];
}

- (BOOL)isNullObject:(id)obj{
    if (obj != nil && ![obj isKindOfClass:[NSNull class]]) {
        return NO;
    } else {
        return YES;
    }
}

-(NSString*) getFileNameFromURL:(NSURL*) url {
    return [[url.path componentsSeparatedByString:@"/"] lastObject];
}

-(void) addToFavorites {
    self.isFavorite = YES;
    if([self.delegate respondsToSelector:@selector(willChangeToFavorite:)]){
        [self.delegate willChangeToFavorite:self];
    }
}
-(void) removeToFavorites {
    self.isFavorite = NO;
    if([self.delegate respondsToSelector:@selector(willChangeToFavorite:)]){
        [self.delegate willChangeToFavorite:self];
    }
}

@end
