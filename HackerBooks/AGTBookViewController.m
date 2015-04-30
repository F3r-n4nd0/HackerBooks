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


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadBook:) name:FINISH_DOWNLOAD_BOOK object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
     [[NSNotificationCenter defaultCenter] removeObserver:self name:FINISH_DOWNLOAD_BOOK object:nil];
    [super viewWillDisappear:animated];
}

-(void)downloadBook:(NSNotification*) notification {
    if(notification.object == self.book) {
        [self updateStatusPdfBook];
    }
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
    
    [self updateStatusPdfBook];
}

-(void) updateStatusPdfBook {
    if([self.book isPdfDownloaded]){
        [self.buttonDownloadAndView setTitle:@"VIEW BOOK" forState:UIControlStateNormal];
        [self.buttonDownloadAndView setEnabled:YES];
    } else if ([self.book isDownloadingPdf]){
        [self.buttonDownloadAndView setTitle:@"DOWNLOADING BOOK" forState:UIControlStateNormal];
        [self.buttonDownloadAndView setEnabled:NO];
    } else {
        [self.buttonDownloadAndView setTitle:@"DOWNLOAD BOOK" forState:UIControlStateNormal];
        [self.buttonDownloadAndView setEnabled:YES];
    }
    
}
#pragma mark - events views

- (IBAction)changeSwitchIsFavorite:(UISwitch *)sender {
    if(sender.isOn) {
        [self.book addToFavorites];
    } else {
        [self.book removeToFavorites];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_BOOK object:self.book];
}

- (IBAction)clickButtonViewOrDownload:(UIButton *)sender {
    if([self.book isPdfDownloaded]){
        ReaderDocument* readerDocument = [[ReaderDocument alloc] initWithFilePath:[self.book downloadPdf] password:nil];
        ReaderViewController* readerViewController = [[ReaderViewController alloc] initWithReaderDocument:readerDocument];
        [self.navigationController pushViewController:readerViewController animated:YES];
    } else {
        [self.book downloadPdf];
        [self updateStatusPdfBook];
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
