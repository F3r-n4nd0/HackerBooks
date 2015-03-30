//
//  AGTLibrary.h
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

@import Foundation;

@class AGTBook;

@interface AGTLibrary : NSObject

-(NSUInteger) booksCount;
-(NSArray*) tags;
-(NSUInteger) bookCountForTag:(NSString*) tag;
-(NSArray*) booksForTag:(NSString *) tag;
-(AGTBook*) bookForTag:(NSString*) tag atIndex:(NSUInteger) index;

@end
