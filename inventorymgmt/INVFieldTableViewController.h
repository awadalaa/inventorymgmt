//
//  INVItemDetailViewController.h
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormField.h"

@class CDItem; //let the view know about the class

@interface INVFieldTableViewController : UITableViewController <UITextFieldDelegate>
{
    CDItem *currentItem; //a reference to our current item
    FormField* nameField_ ;
    FormField* itemField_ ;
    FormField* currentQtyField_ ;
    FormField* stockQtyField_ ;
    FormField* priceField_ ;
    FormField* costField_ ;
    FormField* currencyField_ ;
    FormField* colorField_ ;
    FormField* weightField_ ;
}
@property (nonatomic, strong) UITableView *tableView;
- (id)initWithItem:(CDItem *)item; //load the view for an item
//- (IBAction)deleteItem:(id)sender;

@end