//
//  AppDelegate.m
//  HackerBooks
//
//  Created by Fernando on 3/30/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTLibrary.h"
#import "Settings.h"
#import "AGTLibraryTableViewController.h"
#import "AGTDownloader.h"
#import "AGTBookViewController.h"

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self verifyIsFirstRun];
    [self initWindow];
    [self downloadJsonDataIfNecessary];

    NSData* dataLocalJson = [AGTDownloader getDataFromLocalDocumentsWithName:NAME_LOCAL_FILE_DATA];
    AGTLibrary *library = [AGTLibrary initWithJsonData:dataLocalJson];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self configureForPadWithModel:library];
    }else{
        [self configureForPhoneWithModel:library];
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void) initWindow {
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
}

-(void) verifyIsFirstRun {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:IS_FIRST_RUN]){
        [self setFirstRun:TRUE];
        [defaults setObject:[NSDate date] forKey:IS_FIRST_RUN];
        [defaults synchronize];
    }else{
        [self setFirstRun:FALSE];
    }
}


-(void) downloadJsonDataIfNecessary {
    if(self.firstRun || ![AGTDownloader isHasDownloadedFileFromName:NAME_LOCAL_FILE_DATA]) {
        [self readAsyncDataFromURL:[NSURL URLWithString:URL_JSON_DATA]];
    }
}



-(void) readAsyncDataFromURL:(NSURL*) url {
    __weak typeof(self) weakSelf = self;
    [AGTDownloader readAndSaveDataFromURL:url andSaveWithName:NAME_LOCAL_FILE_DATA handleError:^(NSError *error) {
        [weakSelf showsingleAlertWithTitle:@"Error Download Data" message:error.localizedDescription];
    }];
}

-(void) configureForPadWithModel:(AGTLibrary*)library{
    
    AGTLibraryTableViewController *libraryVC = [[AGTLibraryTableViewController alloc] initWithModel:library style:UITableViewStylePlain];
    
    AGTBookViewController *bookVC = [[AGTBookViewController alloc] initWithBook:[library firstBook]];
    
    UINavigationController *uNav = [UINavigationController new];
    [uNav pushViewController:libraryVC animated:NO];
    
    UINavigationController *cNav = [UINavigationController new];
    [cNav pushViewController:bookVC animated:NO];
    
    UISplitViewController *splitVC = [[UISplitViewController alloc]init];
    splitVC.viewControllers = @[uNav, cNav];
    
    splitVC.delegate = bookVC;
    libraryVC.delegate = bookVC;
    
    self.window.rootViewController = splitVC;
    
}

-(void) configureForPhoneWithModel:(AGTLibrary*)library{
    
    AGTLibraryTableViewController *libraryVC = [[AGTLibraryTableViewController alloc]
                                           initWithModel:library
                                           style:UITableViewStylePlain];
    UINavigationController *navVC = [UINavigationController new];
    [navVC pushViewController:libraryVC
                     animated:NO];
    libraryVC.delegate = libraryVC;
    self.window.rootViewController = navVC;
}



#pragma mark - Helper

-(void) showsingleAlertWithTitle:(NSString*)title
                         message:(NSString*)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



@end
