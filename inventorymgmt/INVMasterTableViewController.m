//
//  INVMasterTableViewController.m
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import "INVMasterTableViewController.h"
#import "INVFieldTableViewController.h"
#import "CDItem.h"
#import "CDItemStore.h"

@implementation INVMasterTableViewController{
    BOOL isSearching;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSearchView];
}


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
        
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
        [[self navigationItem] setRightBarButtonItem:addItem];
        
        searchData = [[NSMutableArray alloc] init];
        
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
    INVFieldTableViewController *detailView = [[INVFieldTableViewController alloc] initWithItem:item];
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchData count];
        
    } else {
        return [items count];
    }
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
    
    // Display recipe in the table cell
    CDItem *item  = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        item = [searchData objectAtIndex:indexPath.row];
    } else {
        item = [items objectAtIndex:[indexPath row]];
    }
    
    //Display the information about our item in the cell
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",[item name]]];
    [[cell detailTextLabel] setText:[item itemType]];
    [[cell detailTextLabel] setText:[item itemType]];
    
    
    /* Create a UILabel.
     Set textAlignment as UITextAlignmentCenter.
     Change its cornerRadius.
     Add a drop shadow using shadowColor, shadowOffset(a positive offest) ,etc.,
     Set label's text.
     Resize label's width to fit the text.
     Set it as cell's accessoryView.*/
    
    if (item.qty){
        UILabel *badge ;//[[UILabel alloc] init];
        if([item.qty intValue] < 10)
            badge = [[UILabel alloc]initWithFrame:CGRectMake(10, -10, 40, 30)];
        else if([item.qty integerValue] < 100)
            badge = [[UILabel alloc]initWithFrame:CGRectMake(5, -10, 40, 30)];
        else if([item.qty integerValue] < 1000)
            badge = [[UILabel alloc]initWithFrame:CGRectMake(5, -10, 40, 30)];
        badge.layer.cornerRadius = 5;
        badge.layer.masksToBounds = YES;
        badge.text = [NSString stringWithFormat:@"%@",item.qty];
        badge.textAlignment = NSTextAlignmentCenter;
        badge.textColor = [UIColor whiteColor];
        badge.backgroundColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:235/255.0f alpha:1.0f];
        cell.accessoryView = badge;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get the item that was selected
    CDItem *item = nil;
    if (self.searchDisplayController.active) {
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        item = [searchData objectAtIndex:indexPath.row];
    } else {
        item = [items objectAtIndex:indexPath.row];
    }

    
    //load the item on the screen
    INVFieldTableViewController *detailView = [[INVFieldTableViewController alloc] initWithItem:item];
    [[self navigationController] pushViewController:detailView animated:YES];
}

#pragma mark - UISearchView delegates

-(void)loadSearchView {
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    self.tableView.tableHeaderView = searchBar;
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchData = (NSMutableArray *)[items filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

@end
