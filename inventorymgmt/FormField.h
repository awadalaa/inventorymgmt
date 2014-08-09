//
//  FormField.h
//  inventorymgmt
//
//  Created by Alaa Awad on 8/9/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormField : NSObject
    @property (nonatomic, retain) NSString * name;
    @property (nonatomic, retain) NSString * placeholder;
    @property (nonatomic, retain) NSString * text;
    @property (nonatomic, retain) NSString * type;
    @property (nonatomic, retain) UITextField * field;
@end
