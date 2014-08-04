//
//  INVAppDelegate.h
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> //Import so we can work with Core Data

@interface INVAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSManagedObjectModel *sharedModel; //holder for our model
    NSManagedObjectContext *sharedContext; //holder for our context
}

@property (strong, nonatomic) UIWindow *window;

- (NSManagedObjectModel *)sharedModel; //Getter for our instance variable
- (NSManagedObjectContext *)sharedContext; //Getter for our instance variable

@end
