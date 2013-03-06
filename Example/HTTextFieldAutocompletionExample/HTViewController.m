//
//  HTViewController.m
//  HTTextFieldAutocompletionExample
//
//  Created by Jonathan Sibley on 12/26/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTViewController.h"
#import "HTAutocompleteManager.h"

@interface HTViewController ()

@end

@implementation HTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set a default data source for all instances.  Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    
    self.emailTextField.autocompleteType = HTAutocompleteTypeEmail;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.favoriteColorTextField.autocompleteType = HTAutocompleteTypeColor;
    self.favoriteColorTextField.delegate = self;
    self.favoriteColorTextField.ignoreCase = NO;
    self.favoriteColorTextField.multiRecognitionEnabled = YES;
    self.favoriteColorTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    // Dismiss the keyboard when the user taps outside of a text field
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewDidUnload
{
    [self setEmailTextField:nil];
    [self setFavoriteColorTextField:nil];
    
    [super viewDidUnload];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.emailTextField resignFirstResponder];
    [self.favoriteColorTextField resignFirstResponder];
}

@end
