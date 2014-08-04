//
//  CDItemStore.m
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import "CDItemStore.h"
#import "CDItem.h"
#import "INVAppDelegate.h"

@implementation CDItemStore

- (id)init
{
    self = [super init];
    
    if (self)
    {
        INVAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        context = [appDelegate sharedContext];
        model = [appDelegate sharedModel]; // Get reference to our shared model
    }
    
    return self;
}

- (CDItem *)createItem
{
    CDItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"CDItem" inManagedObjectContext:context];
    
    return newItem;
}

- (void)deleteItem:(CDItem *)item
{
    [context deleteObject:item];
}

- (void)saveChanges
{
    NSError *error = nil;
    
    //Save the in memory items to the database
    [context save:&error];
    
    if (error)
    {
        NSLog(@"Error occurred while saving. Error: %@", [error localizedDescription]);
    }
}

- (NSArray *)allItems
{
    //The Fetch Request is the foundation for what we'll ask Core Data for. Think of it as the shell of your question
    //We are currently saying "Core Data I want something"
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //We ask the model (our database schema) for the information (schema) of the object we want
    NSEntityDescription *description = [[model entitiesByName] objectForKey:@"CDItem"];
    
    //Tell our request what we are looking for. Now we are saying "Core Data I want my CDItems"
    [request setEntity:description];
    
    //This will organize our results by the field "name" we can use any field that is on the object
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    //"Core Data I want my CDItems in Alphabetical order based on name"
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error = nil;
    
    //Sends our request to core data and holds the result
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    //Reports any errors that might have occured
    if (error)
    {
        NSLog(@"Eror occured while fetching items. Error: %@", [error localizedDescription]);
    }
    
    return result;
}

@end