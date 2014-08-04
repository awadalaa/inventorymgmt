//
//  INVItemDetailViewController.m
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import "INVItemDetailViewController.h"
#import "CDItem.h"
#import "CDItemStore.h"

#define PICKER_MIN 0
#define PICKER_MAX 300
@implementation INVItemDetailViewController

// Synthesis (provide access/generate a few variables for) our properties
@synthesize nameTextField, itemTypeTextField;

- (id)initWithItem:(CDItem *)item
{
    self = [super init];
    
    if (self)
    {
        //hold on to the reference for our item
        currentItem = item;
    }
    
    return self;
}

- (IBAction)deleteItem:(id)sender
{
    //Create a new instance of the item store
    CDItemStore *itemStore = [[CDItemStore alloc] init];
    
    //Delete the current object
    [itemStore deleteItem:currentItem];
    
    //Navigate back to the table view
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //load text field names
    [nameTextField setText:[currentItem name]];
    [itemTypeTextField setText:[currentItem itemType]];
    self.nameTextField.delegate = self;
    self.itemTypeTextField.delegate = self;
    self.qtyPickerField.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated
{
    //Keep the regular behavior
    [super viewWillDisappear:animated];
    
    //Force the keyboard to dismiss so our changes are saved to our item
    [nameTextField resignFirstResponder];
    [itemTypeTextField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"in textFieldDidEndEditing");
    if ([textField isEqual:nameTextField])
    {
        //if the text field is the name field save the data to the name value

        [currentItem setName:[textField text]];
    }
    else if ([textField isEqual:itemTypeTextField])
    {
        //if the text field is the itemType field save the data to the itemType value

        [currentItem setItemType:[textField text]];
    }
    NSLog(@"%@", currentItem);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Dismissed the keyboard when the user selects the Done button on the keyboard
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (PICKER_MAX-PICKER_MIN+1);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", (row+PICKER_MIN)];
}

@end

