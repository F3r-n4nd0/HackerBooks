//
//  AGTLibraryTableViewController.h
//  HackerBooks
//
//  Created by Fernando on 3/31/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

@import UIKit;

@class AGTBook;
@class AGTLibrary;
@class AGTLibraryTableViewController;

#import "AGTLibrary.h"

@protocol AGTLibraryTableViewControllerDelegate <NSObject>

-(void) libraryTableViewController:(AGTLibraryTableViewController*) viewController disSelectBook:(AGTBook*) book;

@end


@interface AGTLibraryTableViewController : UITableViewController <AGTLibraryTableViewControllerDelegate,AGTLibraryDelegate>

@property (strong, nonatomic) AGTLibrary* library;
@property (weak, nonatomic) id<AGTLibraryTableViewControllerDelegate> delegate;

-(id) initWithModel:(AGTLibrary*) library
              style:(UITableViewStyle)style;

@end

