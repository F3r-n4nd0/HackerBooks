//
//  AGTLibrary.m
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import "AGTLibrary.h"
#import "AGTBook.h"
#import "Settings.h"
#import "AGTDownloader.h"

@interface AGTLibrary()

@property (nonatomic,strong) NSMutableArray* favorites;
@property (nonatomic,strong) NSMutableArray* books;
@property (nonatomic) BOOL hasLoadBooks;

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
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:FAVORITES_BOOKS] ;
    if(array) {
        self.favorites = array;
    }else {
        self.favorites = [NSMutableArray array];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLibraryData:) name:NOTIFICATION_LOAD_BOOK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBook:) name:NOTIFICATION_CHANGE_BOOK object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOAD_BOOK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CHANGE_BOOK object:nil];
}

-(void)reloadLibraryData:(NSNotification*) notification {
    NSData* dataLocalJson = [AGTDownloader getDataFromLocalDocumentsWithName:NAME_LOCAL_FILE_DATA];
    [self loadBooksfromJsonData:dataLocalJson];
    if([self.delegate respondsToSelector:@selector(modifyDataLibrary)]){
        [self.delegate modifyDataLibrary];
    }
}

-(void)updateBook:(NSNotification*) notification {
    if([self.delegate respondsToSelector:@selector(modifyDataLibrary)]){
        [self.delegate modifyDataLibrary];
    }
}

-(void) loadBooksfromJsonData:(NSData*) data {
    if(data == nil) {
        self.hasLoadBooks = NO;
        return;
    }
    NSError* error;
    id arrayBooks = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(error) {
        NSLog(@"Error try to read json data : %@",error);
    }
    [self.books removeAllObjects];
    if([arrayBooks isKindOfClass:[NSArray class]]) {
        for (id bookDictionary in arrayBooks) {
            if([bookDictionary isKindOfClass:[NSDictionary class]]) {
                AGTBook* book = [AGTBook initWithDictionary:bookDictionary];
                [self.books addObject:book];
                [self updateIsFavorite:book];
            }
        }
    }
     self.hasLoadBooks = YES;
}

-(void)updateIsFavorite:(AGTBook*) book {
    if([self.favorites containsObject:book.title]) {
        [book addToFavorites];
    } else {
        [book removeToFavorites];
    }
    book.delegate = self;
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
    NSString *titleFistBook = [[NSUserDefaults standardUserDefaults] stringForKey:LAST_BOOK];
    for (AGTBook *book in self.books) {
        if([book.title isEqualToString:titleFistBook]){
            return book;
        }
    }
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

#pragma mark - delegate Book

-(void)willChangeToFavorite:(AGTBook *)book {
    if(book.isFavorite) {
        [self.favorites addObject:book.title];
    } else {
        [self.favorites removeObject:book.title];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[self.favorites copy] forKey:FAVORITES_BOOKS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end