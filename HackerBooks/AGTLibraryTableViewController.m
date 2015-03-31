//
//  AGTLibraryTableViewController.m
//  HackerBooks
//
//  Created by Fernando on 3/31/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import "AGTLibraryTableViewController.h"
#import "AGTLibrary.h"
#import "AGTBook.h"

@interface AGTLibraryTableViewController ()

@end

@implementation AGTLibraryTableViewController

-(id) initWithModel:(AGTLibrary*) library
              style:(UITableViewStyle)style{
    
    if (self = [super initWithStyle:style]) {
        _library = library;
        self.title = @"List Books";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.library tags].count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return [self.library bookFavoritesCount];
    }
    return [self.library bookCountForTag:[self.library.tags objectAtIndex:section-1]];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Favorites";
    }
    return [self.library.tags objectAtIndex:section-1];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AGTBook *book;
    if(indexPath.section == 0) {
        book = [self.library bookFavoriteForIndex:indexPath.row];
    } else {
        book = [self.library bookForTag:[self.library.tags objectAtIndex:indexPath.section -1] atIndex:indexPath.row];
    }
    static NSString *cellId = @"BookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellId];
    }
    [cell.textLabel setText:book.title];
    return cell;
}


@end
