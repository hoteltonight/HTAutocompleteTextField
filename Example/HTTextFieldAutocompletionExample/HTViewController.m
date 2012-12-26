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

    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];

    self.emailTextField.autocompleteType = HTAutocompleteTypeEmail;

    self.favoriteColorTextField.autocompleteType = HTAutocompleteTypeColor;
    self.favoriteColorTextField.ignoreCase = NO;

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
