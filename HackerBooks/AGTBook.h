//
//  AGTBook.h
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

@import UIKit;
@import Foundation;

@class AGTBook;

@protocol AGTBookDelegate <NSObject>

-(void) willChangeToFavorite:(AGTBook*) book;

@end

@interface AGTBook : NSObject

@property (weak, nonatomic) id<AGTBookDelegate> delegate;
@property (copy, nonatomic) NSString* title;
@property (strong, nonatomic) NSArray* authors;
@property (strong, nonatomic) NSArray* tags;
@property (strong, nonatomic) NSURL* urlImage;
@property (strong, nonatomic) NSURL* urlPDF;
@property (readonly) BOOL isFavorite;

+(id)initWithDictionary:(NSDictionary*)dictionary;
-(id)initWithDictionary:(NSDictionary*)dictionary;
-(BOOL)hasTag:(NSString*) tag;
-(UIImage*)getimageOrDownload;
-(NSString*) downloadPdf;
-(BOOL) isPdfDownloaded;
-(BOOL) isDownloadingPdf;
-(void) addToFavorites;
-(void) removeToFavorites;
@end
