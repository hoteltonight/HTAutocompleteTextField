//
//  HTSampleFieldsTableViewController.m
//  HTTextFieldAutocompletionExample
//
//  Created by Jonathan Sibley on 12/26/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTSampleFieldsTableViewController.h"
#import "HTAutocompleteManager.h"

@interface HTSampleFieldsTableViewController ()

@end

@implementation HTSampleFieldsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set a default data source for all instances.  Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    

    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;

    self.nameTextField.autocompleteType = HTAutocompleteTypeColor;
    
    // Dismiss the keyboard when the user taps outside of a text field
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.emailTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

@end
