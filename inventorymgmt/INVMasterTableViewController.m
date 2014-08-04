//
//  INVMasterTableViewController.m
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import "INVMasterTableViewController.h"
#import "INVItemDetailViewController.h"
#import "CDItem.h"
#import "CDItemStore.h"

@implementation INVMasterTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshTable];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {
        [self setTitle:@"Inventory List"];
        
        rows = [[NSArray alloc] init]; 
        
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
        [[self navigationItem] setRightBarButtonItem:addItem];
        
    }
    
    return self;
}

- (void)addItem
{
    //Create an instance of our data store
    CDItemStore *itemStore = [[CDItemStore alloc] init];
    
    //Get a new CDItem
    CDItem *item = [itemStore createItem];
    
    //Create an instance of the detail view and show it
    INVItemDetailViewController *detailView = [[INVItemDetailViewController alloc] initWithItem:item];
    [[self navigationController] pushViewController:detailView animated:YES];
    
}

- (void)refreshTable
{
    CDItemStore *itemStore = [[CDItemStore alloc] init];
    [itemStore saveChanges]; //save all changes
    
    items = [itemStore allItems];
    
    [[self tableView] reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Return the number of sections in the table we only have one right now.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return the number of rows in the section. Because we only have one section rows will represent the rows in that section
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Retrieve our cell if one has already been created in memory.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //If no cell is available create a new one
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Retrieve our item from our collection of CDItems
    CDItem *item = [items objectAtIndex:[indexPath row]];
    
    //Display the information about our item in the cell
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@",[[item qty] stringValue],[item name]]];
    [[cell detailTextLabel] setText:[item itemType]];
        [[cell detailTextLabel] setText:[item itemType]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get the item that was selected
    CDItem *item = [items objectAtIndex:[indexPath row]];
    
    //load the item on the screen
    INVItemDetailViewController *detailView = [[INVItemDetailViewController alloc] initWithItem:item];
    [[self navigationController] pushViewController:detailView animated:YES];
}

@end
