//
//  AGTBook.m
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import "AGTBook.h"

@implementation AGTBook

-(BOOL)hasTag:(NSString *)tag {
    return [self.tags containsObject:tag];
}

@end
