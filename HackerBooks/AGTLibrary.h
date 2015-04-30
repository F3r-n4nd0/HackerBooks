//
//  AGTLibrary.h
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

@import Foundation;

#import "AGTBook.h"

@protocol AGTLibraryDelegate <NSObject>
-(void)modifyDataLibrary;
@end

@interface AGTLibrary : NSObject <AGTBookDelegate>

@property (weak, nonatomic) id<AGTLibraryDelegate> delegate;
@property (readonly) BOOL hasLoadBooks;

+(id)initWithJsonData:(NSData*) data;

-(id)initWithJsonData:(NSData*) data;

-(NSUInteger) booksCount;
-(NSUInteger) bookFavoritesCount;
-(NSArray*) tags;
-(NSUInteger) bookCountForTag:(NSString*) tag;
-(NSArray*) booksForTag:(NSString *) tag;
-(AGTBook*) bookFavoriteForIndex:(NSUInteger)index;
-(AGTBook*) bookForTag:(NSString*) tag atIndex:(NSUInteger) index;
-(AGTBook*) firstBook;
-(void) changeBook:(AGTBook*) book;

@end
