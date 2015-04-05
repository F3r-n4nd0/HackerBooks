//
//  AGTLibrary.m
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import "AGTLibrary.h"
#import "AGTBook.h"

@interface AGTLibrary()

@property (nonatomic,strong) NSMutableArray* books;

@end

@implementation AGTLibrary


#pragma - initializers

+(id) initWithJsonData:(NSData *)data {
    return [[self alloc] initWithJsonData:data];
}


-(id) initWithJsonData:(NSData *)data {
    if(self = [super init]) {
        [self initializeDefault];
        [self loadBooksfromJsonData:data];
    }
    return self;
}


-(void) initializeDefault {
    self.books = [NSMutableArray array];
}

-(void) loadBooksfromJsonData:(NSData*) data {
    if(data == nil) {
        return;
    }
    NSError* error;
    id arrayBooks = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(error) {
        NSLog(@"Error try to read json data : %@",error);
    }
    if([arrayBooks isKindOfClass:[NSArray class]]) {
        for (id bookDictionary in arrayBooks) {
            if([bookDictionary isKindOfClass:[NSDictionary class]]) {
                AGTBook* book = [AGTBook initWithDictionary:bookDictionary];
                [self.books addObject:book];
            }
        }
    }
}

#pragma - books handlers

-(NSUInteger)booksCount {
    return [self.books count];
}

-(NSArray*)tags {
    NSMutableArray* tags = [NSMutableArray array];
    for (AGTBook* book in self.books) {
        [tags addObjectsFromArray:book.tags];
    }
    return [self sortStringInArray:[self removeDuplicatesFromArray:tags]];
}

-(NSUInteger)bookCountForTag:(NSString *)tag {
    NSUInteger resultCount = 0;
    for (AGTBook* book in self.books) {
        if([book hasTag:tag]) {
            resultCount++;
        }
    }
    return resultCount;
}

-(NSArray*)booksForTag:(NSString *)tag {
    NSMutableArray* booksWithTag = [NSMutableArray array];
    for (AGTBook* book in self.books) {
        if([book hasTag:tag]) {
            [booksWithTag addObject:book];
        }
    }
    return booksWithTag.count > 0 ?[NSArray arrayWithArray:booksWithTag]: nil;
}

-(AGTBook*)bookForTag:(NSString *)tag atIndex:(NSUInteger)index {
    NSArray* bookWithTag = [self booksForTag:tag];
    return [bookWithTag objectAtIndex:index];
}

-(AGTBook*)bookFavoriteForIndex:(NSUInteger)index {
    NSArray* booksFavorites = [self booksFavorites];
    return [booksFavorites objectAtIndex:index];
}

-(NSUInteger)bookFavoritesCount {
    NSUInteger resultCount = 0;
    for (AGTBook* book in self.books) {
        if([book isFavorite]) {
            resultCount++;
        }
    }
    return resultCount;
}

-(NSArray*)booksFavorites {
    NSMutableArray* booksFavorites = [NSMutableArray array];
    for (AGTBook* book in self.books) {
        if([book isFavorite]) {
            [booksFavorites addObject:book];
        }
    }
    return [booksFavorites copy];
}

-(AGTBook*) firstBook {
    return [self.books firstObject];
}

-(void) changeBook:(AGTBook*) book {
    if([self.books containsObject:book]) {
        NSUInteger index = [self.books indexOfObject:book];
        [self.books replaceObjectAtIndex:index withObject:book];
    }
}


#pragma - Helper

-(NSArray*)removeDuplicatesFromArray:(NSArray*) array {
    return [[NSSet setWithArray:array] allObjects];
}

-(NSArray*)sortStringInArray:(NSArray*) array {
    return [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@end