//
//  INVNavigationController.m
//  inventorymgmt
//
//  Created by Alaa Awad on 8/4/14.
//  Copyright (c) 2014 Technalaa. All rights reserved.
//

#import "INVNavigationController.h"

@interface INVNavigationController ()

@end

@implementation INVNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationBar.barTintColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:235/255.0f alpha:1.0f];
        self.navigationBar.translucent = NO;
        
        NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.navigationBar.titleTextAttributes];
        [textAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        self.navigationBar.titleTextAttributes = textAttributes;

    }else{
        self.navigationBar.tintColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:235/255.0f alpha:1.0f];
    }
    
}

@end
