//
//  INVItemDetailViewController.m
//  inventorymgmt
//
//  Created by Alaa Awad on 8/3/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import "INVFieldTableViewController.h"
#import "CDItem.h"
#import "CDItemStore.h"

@implementation INVFieldTableViewController{
    NSArray *fields; /* of FormFields */
    NSArray *fieldSections;
}

- (id)initWithItem:(CDItem *)item
{
    self = [super init];
    
    if (self)
    {
        currentItem = item;
    }
    
    return self;
}


/*
- (IBAction)deleteItem:(id)sender
{
    //Create a new instance of the item store
    CDItemStore *itemStore = [[CDItemStore alloc] init];
    //Delete the current object
    [itemStore deleteItem:currentItem];
    //Navigate back to the table view
    [[self navigationController] popViewControllerAnimated:YES];
}
*/

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadFields];
    
}

-(void)loadFields{
    nameField_ = [self makeTextField:@"name" placeholder:@"fleece" type:@"String" text:nil];
    itemField_ = [self makeTextField:@"category" placeholder:@"clothing" type:@"String" text:nil];
    currentQtyField_ = [self makeTextField:@"current qty" placeholder:@"30" type:@"Number" text:nil];
    stockQtyField_ = [self makeTextField:@"original qty" placeholder:@"50" type:@"Number" text:nil];
    priceField_ = [self makeTextField:@"price" placeholder:@"1.25" type:@"Number" text:nil];
    costField_ = [self makeTextField:@"cost" placeholder:@"0.75" type:@"Number" text:nil];
//    currencyField_ = [self makeTextField:@"currency" placeholder:@"USD" type:@"Stirng" text:nil];
    colorField_ = [self makeTextField:@"color" placeholder:@"red" type:@"String" text:nil];
    weightField_ = [self makeTextField:@"weight" placeholder:@"13" type:@"Number" text:nil];
    fields = [NSArray arrayWithObjects:@[nameField_,itemField_,currentQtyField_,stockQtyField_],
              @[priceField_,costField_],@[colorField_,weightField_], nil];
    fieldSections = [NSArray arrayWithObjects: @"Inventory",@"Price",@"Details",nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",currentItem);
    //load text field names

    if(currentItem.name) [nameField_.field setText:[currentItem name]];
    if(currentItem.itemType) [itemField_.field setText:[currentItem itemType]];
    if(currentItem.qty) [currentQtyField_.field setText:[[currentItem qty] stringValue]];
    nameField_.field.delegate = self;
    itemField_.field.delegate = self;
    currentQtyField_.field.delegate = self;
    nameField_.field.returnKeyType = UIReturnKeyDone;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    //Keep the regular behavior
    [super viewWillDisappear:animated];
    
    //Force the keyboard to dismiss so our changes are saved to our item
    [nameField_.field resignFirstResponder];
    [itemField_.field resignFirstResponder];
    [currentQtyField_.field resignFirstResponder];
    [stockQtyField_.field resignFirstResponder];
}

-(FormField *) makeTextField: (NSString*)name
                 placeholder: (NSString*)placeholder
                        type: (NSString *)type
                        text: (NSString *)text{
    FormField *ff = [[FormField alloc] init];
    ff.name = name;
    ff.placeholder = placeholder;
    ff.type = type;
    
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = placeholder;
    tf.text = text;
    tf.autocorrectionType = UITextAutocorrectionTypeNo ;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    tf.frame = CGRectMake(120, 12, 170, 30);
//    tf.textAlignment = UITextAlignmentRight;
    if ([type isEqual:@"Number"]){
        tf.keyboardType = UIKeyboardTypeDecimalPad;
    }
    ff.field = tf;
    return ff ;
}

#pragma mark - textField delegates


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        cell = (UITableViewCell *) textField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        cell = (UITableViewCell *) textField.superview.superview.superview;
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
    }
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"in textFieldDidEndEditing");
    if ([textField isEqual:nameField_.field])
    {
        [currentItem setName:[textField text]];
    }
    else if ([textField isEqual:itemField_.field])
    {
        [currentItem setItemType:[textField text]];
    }
    else if ([textField isEqual:currentQtyField_.field])
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * qty = [f numberFromString:textField.text];
        [currentItem setQty:qty];
    }
    NSLog(@"%@", currentItem);
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.keyboardType==UIKeyboardTypeDecimalPad){
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890.-"] invertedSet];
        if ([string rangeOfCharacterFromSet:cs].location == NSNotFound) {
            
            NSString *newString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
            
            // check number of decimal chars used (maximum of one)
            NSArray *array = [newString componentsSeparatedByString:@"."];
            if ([array count] <= 2) {
                
                // check negative chars (maximum of one AND it must be at the front)
                array = [newString componentsSeparatedByString:@"-"];
                
                if (1 == [array count]) {
                    return YES; // no negatives
                } else if (2 == [array count]) {
                    return ('-' == [newString characterAtIndex:0]); // return YES if first char is negative only
                } else {
                    return NO; // too many negative chars
                }
            } else {
                return NO; // too many decimal chars
            }
        } else {
            return NO; // invalid character
        }
    }
    return YES;
}

#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string =[fieldSections objectAtIndex:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Return the number of sections in the table we only have one right now.
    return [fieldSections count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [fields[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Retrieve our cell if one has already been created in memory.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    //If no cell is available create a new one
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [fields[indexPath.section][indexPath.row] name];
    [cell addSubview:[fields[indexPath.section][indexPath.row] field]];
    return cell;
}


@end

