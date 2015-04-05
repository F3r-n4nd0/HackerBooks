//
//  AGTBookReaderViewController.m
//  HackerBooks
//
//  Created by Fernando on 4/5/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import <Reader/ReaderViewController.h>

#import "AGTBookViewController.h"
#import "AGTBook.h"
#import "Settings.h"

@implementation AGTBookViewController


-(id) initWithBook:(AGTBook*)book {
    if(self = [self init]) {
        _book = book;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateDataBook];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateDataBook {
    [self.imageViewBookCover setImage:[self.book getimageOrDownload]];
    [self.labelTitle setText:self.book.title];
    [self.labelAuthors setText:[self.book.authors componentsJoinedByString:@" , "]];
    [self.labelTag setText:[self.book.tags componentsJoinedByString:@" , "]];
    [self.switchIsFavorite setOn:self.book.isFavorite animated:YES];
    
    if([self.book isPdfDownloaded]){
        [self.buttonDownloadAndView setTitle:@"VIEW" forState:UIControlStateNormal];
    } else {
        [self.buttonDownloadAndView setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
    }
}

#pragma mark - events views

- (IBAction)changeSwitchIsFavorite:(UISwitch *)sender {
    [self.book setIsFavorite:sender.isOn];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_BOOK object:self.book];
}

- (IBAction)clickButtonViewOrDownload:(UIButton *)sender {
    if([self.book isPdfDownloaded]){
        ReaderDocument* readerDocument = [[ReaderDocument alloc] initWithFilePath:[self.book downloadPdf] password:nil];
        ReaderViewController* readerViewController = [[ReaderViewController alloc] initWithReaderDocument:readerDocument];
        [self.navigationController pushViewController:readerViewController animated:YES];
    } else {
        [self.book downloadPdf];
    }
}


#pragma mark - AGTLibraryTableViewControllerDelegate

-(void)libraryTableViewController:(AGTLibraryTableViewController *)viewController disSelectBook:(AGTBook *)book {
    self.book = book;
    [self updateDataBook];
}


#pragma mark - UISplitViewControllerDelegate

-(void) splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    // Averiguar si la tabla se ve o no
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        
        // La tabla está oculta y cuelga del botón
        // Ponemos ese botón en mi barra de navegación
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }else{
        // Se muestra la tabla: oculto el botón de la
        // barra de navegación
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    
}




@end
