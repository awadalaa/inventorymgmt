//
//  INVItemDetailViewController.h
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDItem; //let the view know about the class

@interface INVItemDetailViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate>
{
    CDItem *currentItem; //a reference to our current item
    NSMutableArray *qty;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTypeTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *qtyPickerField;

- (id)initWithItem:(CDItem *)item; //load the view for an item
- (IBAction)deleteItem:(id)sender;

@end