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
    [self.tableView reloadData];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
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
    CDItemStore *itemStore = [[CDItemStore alloc] init];
    CDItem *item = [itemStore createItem];
    INVFieldTableViewController *detailView = [[INVFieldTableViewController alloc] initWithItem:item];
    [[self navigationController] pushViewController:detailView animated:YES];
}

- (void)refreshTable
{
    CDItemStore *itemStore = [[CDItemStore alloc] init];
    [itemStore saveChanges];
    items = [itemStore allItems];
    [[self tableView] reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    CDItem *item  = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        item = [searchData objectAtIndex:indexPath.row];
    } else {
        item = [items objectAtIndex:[indexPath row]];
    }
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",[item name]]];
    [[cell detailTextLabel] setText:[item itemType]];
    [[cell detailTextLabel] setText:[item itemType]];
    
    if (item.qty){
        UILabel *badge;
    if([item.qty intValue] < 10)
        badge = [[UILabel alloc]initWithFrame:CGRectMake(10, -10, 40, 30)];
    else if([item.qty integerValue] < 1000)
        badge = [[UILabel alloc]initWithFrame:CGRectMake(5, -10, 40, 30)];
    else if([item.qty integerValue] < 10000)
        badge = [[UILabel alloc]initWithFrame:CGRectMake(5, -10, 50, 30)];
    else
        badge = [[UILabel alloc]initWithFrame:CGRectMake(5, -10, 60, 30)];
    
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
    CDItem *item = nil;
    if (self.searchDisplayController.active) {
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        item = [searchData objectAtIndex:indexPath.row];
    } else {
        item = [items objectAtIndex:indexPath.row];
    }

    INVFieldTableViewController *detailView = [[INVFieldTableViewController alloc] initWithItem:item];
    [[self navigationController] pushViewController:detailView animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItem:[items objectAtIndex:indexPath.row] atIndexPath:indexPath];
    }
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



- (void)deleteItem:(CDItem *)cdItem atIndexPath:(NSIndexPath *)indexPath
{
    CDItemStore *itemStore = [[CDItemStore alloc] init];
    [itemStore deleteItem:cdItem];
    NSMutableArray *mutableArray = [items mutableCopy];
    [mutableArray removeObject:cdItem];
    items = [NSArray arrayWithArray:mutableArray];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];

}




@end
