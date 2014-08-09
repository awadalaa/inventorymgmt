//
//  INVMasterTableViewController.h
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INVMasterTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSArray *items;
    NSMutableArray *searchData;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}


@end
