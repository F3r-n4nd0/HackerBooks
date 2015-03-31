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

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self verifyIsFirstRun];
    [self initWindow];
    [self downloadJsonDataIfNecessary];
    
    
    NSURL* urlFullPathJsonData = [self fullPathJsonData];
    
    AGTLibrary *library = [AGTLibrary initWithJsonData:[NSData dataWithContentsOfURL:urlFullPathJsonData]];
    
    AGTLibraryTableViewController *libraryListVC = [[AGTLibraryTableViewController alloc]
                                           initWithModel:library
                                                    style:UITableViewStylePlain];
    // Creamos el combinador
    UINavigationController *navVC = [UINavigationController new];
    [navVC pushViewController:libraryListVC
                     animated:NO];

    self.window.rootViewController = navVC;
    
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
    if(self.firstRun || ![self isHasDownloadedData]) {
        [self readAsyncDataFromURL:[NSURL URLWithString:URL_JSON_DATA]];
    }
}

-(BOOL) isHasDownloadedData {
    NSURL* urlFullPathJsonData = [self fullPathJsonData];
    return [urlFullPathJsonData checkResourceIsReachableAndReturnError:nil];
}

-(void) readDataFromURL:(NSURL*) url {
    NSError* error;
    NSData* jsonData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (error) {
        [self showsingleAlertWithTitle:@"Error Download Data" message:error.localizedDescription];
        return;
    }
    NSURL* urlFullPathJsonData = [self fullPathJsonData];
    [jsonData writeToURL:urlFullPathJsonData atomically:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void) readAsyncDataFromURL:(NSURL*) url {
    __weak typeof(self) weak = self;
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   [weak showsingleAlertWithTitle:@"Error Download Data" message:error.localizedDescription];
                                   return;
                               }
                               [weak saveJsonData:data];
                           }];
}

-(NSURL*) fullPathJsonData {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* urlsDocumentDirectory = [fileManager URLsForDirectory:NSDocumentDirectory
                                                          inDomains:NSUserDomainMask];
    NSURL* urlDocument = [urlsDocumentDirectory lastObject];
    return [urlDocument URLByAppendingPathComponent:NAME_LOCAL_FILE_DATA];
}


-(void) showsingleAlertWithTitle:(NSString*)title
                         message:(NSString*)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) saveJsonData:(NSData*) data {
    NSURL* urlFullPathJsonData = [self fullPathJsonData];
    [data writeToURL:urlFullPathJsonData atomically:YES];
}

@end
