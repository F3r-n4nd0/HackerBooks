//
//  AGTBook.m
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import "AGTBook.h"

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

-(BOOL)hasTag:(NSString *)tag {
    return [self.tags containsObject:tag];
}

@end
