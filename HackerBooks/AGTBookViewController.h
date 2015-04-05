//
//  AGTBookReaderViewController.h
//  HackerBooks
//
//  Created by Fernando on 4/5/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

@import UIKit;
@class AGTBook;
@class AGTBookViewController;


#import "AGTLibraryTableViewController.h"


@interface AGTBookViewController : UIViewController <UISplitViewControllerDelegate, AGTLibraryTableViewControllerDelegate>

@property(strong,nonatomic) AGTBook* book;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBookCover;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthors;
@property (weak, nonatomic) IBOutlet UILabel *labelTag;
@property (weak, nonatomic) IBOutlet UISwitch *switchIsFavorite;
@property (weak, nonatomic) IBOutlet UIButton *buttonDownloadAndView;


-(id) initWithBook:(AGTBook*) book;



@end
