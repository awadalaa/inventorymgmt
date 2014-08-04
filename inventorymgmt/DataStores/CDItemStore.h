//
//  CDItemStore.h
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class CDItem; //add item class for the compiler

@interface CDItemStore : NSObject
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model; //Add a holder for our model

}

- (void)saveChanges;
- (void)deleteItem:(CDItem *)item;
- (CDItem *)createItem; //expose method to make it public

- (NSArray *)allItems; //Expose allItems to the reset of the app

@end