//
//  AGTLibraryTableViewController.h
//  HackerBooks
//
//  Created by Fernando on 3/31/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

@import UIKit;

@class AGTLibrary;

@interface AGTLibraryTableViewController : UITableViewController

@property (strong, nonatomic) AGTLibrary* library;


-(id) initWithModel:(AGTLibrary*) library
              style:(UITableViewStyle)style;


@end
