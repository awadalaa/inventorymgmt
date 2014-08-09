//
//  INVAppDelegate.m
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import "INVAppDelegate.h"
#import "INVMasterTableViewController.h"
#import "INVNavigationController.h"

@implementation INVAppDelegate

- (NSManagedObjectModel *)sharedModel
{
    // If sharedModel doesn't exist create one
    if (!sharedModel)
    {
        //Loads up our CoreDataInventorty.xcdatamodeld
        sharedModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return sharedModel;
}

- (NSManagedObjectContext *)sharedContext;
{
    if (!sharedContext)
    {
        //This acts as the connector or coordinator between the model and the context
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self sharedModel]];
        
        //This gets the path to the document directory for the app and sets up a place and file name "store.data" to create our SQLite database
        NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
        NSString *path = [documentDirectory stringByAppendingPathComponent:@"store.data"];
        NSURL *sqlURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil; //Just incase anything funky happens
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        
        //Creates our database at the file path generated above.
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlURL options:options error:&error])
        {
            NSLog(@"Eror occured when creating datastore: %@", [error localizedDescription]);
        }
        
        //Generate the context
        sharedContext = [[NSManagedObjectContext alloc] init];
        
        //Connect our context to our coordinator
        [sharedContext setPersistentStoreCoordinator:coordinator];
        [sharedContext setUndoManager:nil]; //We'll set this as nil we won't be using an Undo Manager in this tutorial
    }
    
    return sharedContext;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    INVMasterTableViewController *masterTableView = [[INVMasterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    INVNavigationController *tableNav = [[INVNavigationController alloc] initWithRootViewController:masterTableView];
    [[self window] setRootViewController:tableNav];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
