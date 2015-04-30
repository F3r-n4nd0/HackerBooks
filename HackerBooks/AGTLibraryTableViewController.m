//
//  AGTLibraryTableViewController.m
//  HackerBooks
//
//  Created by Fernando on 3/31/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import <Reader/ReaderViewController.h>

#import "AGTLibraryTableViewController.h"
#import "AGTLibrary.h"
#import "AGTBook.h"
#import "AGTBookTableViewCell.h"
#import "AGTBookViewController.h"
#import "Settings.h"

@interface AGTLibraryTableViewController ()

@end

@implementation AGTLibraryTableViewController

-(id) initWithModel:(AGTLibrary*) library
              style:(UITableViewStyle)style{
    
    if (self = [super initWithStyle:style]) {
        _library = library;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"List Books"];
    self.library.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"AGTBookTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:[AGTBookTableViewCell cellId]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - notifications

-(void)changeBook:(AGTBook*) book {
    [self.library changeBook:book];
    [self.tableView reloadData];
}

#pragma mark - AGTUniverseTableViewControllerDelegate
-(void)libraryTableViewController:(AGTLibraryTableViewController *)viewController disSelectBook:(AGTBook *)book {

    AGTBookViewController *charVC = [[AGTBookViewController alloc] initWithBook:book];
    [self.navigationController pushViewController:charVC
                                     animated:YES];
}


#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

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
    return [[self.library.tags objectAtIndex:section-1] capitalizedString];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AGTBook *book;
    if(indexPath.section == 0) {
        book = [self.library bookFavoriteForIndex:indexPath.row];
    } else {
        book = [self.library bookForTag:[self.library.tags objectAtIndex:indexPath.section -1] atIndex:indexPath.row];
    }
    AGTBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AGTBookTableViewCell cellId] forIndexPath:indexPath];

    [cell.labelTitle setText:book.title];
    [cell.labelAuthors setText:[book.authors componentsJoinedByString:@" , "]];
    [cell.imageViewCover setImage:[book getimageOrDownload]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AGTBook *book;
    if(indexPath.section == 0) {
        book = [self.library bookFavoriteForIndex:indexPath.row];
    } else {
        book = [self.library bookForTag:[self.library.tags objectAtIndex:indexPath.section -1] atIndex:indexPath.row];
    }
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:disSelectBook:)]) {
        [self.delegate libraryTableViewController:self disSelectBook:book];
    }
    [[NSUserDefaults standardUserDefaults] setObject:book.title forKey:LAST_BOOK];
}

#pragma mark - Delegate Library

-(void)modifyDataLibrary {
    [self.tableView reloadData];
}

@end
