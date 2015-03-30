//
//  AGTBook.h
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

@import Foundation;

@interface AGTBook : NSObject

@property (copy, nonatomic) NSString* title;
@property (strong, nonatomic) NSArray* authors;
@property (strong, nonatomic) NSArray* tags;
@property (strong, nonatomic) NSURL* urlImage;
@property (strong, nonatomic) NSURL* urlPDF;

@end
