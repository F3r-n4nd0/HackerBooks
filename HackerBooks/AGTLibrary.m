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

@property (nonatomic,strong) NSArray* books;

@end

@implementation AGTLibrary

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

-(NSArray*)removeDuplicatesFromArray:(NSArray*) array {
    return [[NSSet setWithArray:array] allObjects];
}

-(NSArray*)sortStringInArray:(NSArray*) array {
    return [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@end
