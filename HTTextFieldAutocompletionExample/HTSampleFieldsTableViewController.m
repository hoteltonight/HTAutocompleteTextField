//
//  HTSampleFieldsTableViewController.m
//  HTTextFieldAutocompletionExample
//
//  Created by Jonathan Sibley on 12/26/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTSampleFieldsTableViewController.h"
#import "HTSampleAutocompleteDataSource.h"

@interface HTSampleFieldsTableViewController ()

@property (nonatomic, weak) IBOutlet HTEmailAutocompleteTextField *emailTextField;
@property (nonatomic, weak) IBOutlet HTAutocompleteTextField *nameTextField;

@end

@implementation HTSampleFieldsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.suggestionLabelExtraPositionOffset = CGPointMake(0, -1);

    self.nameTextField.suggestionDataSource = [HTSampleAutocompleteDataSource new];
    self.nameTextField.suggestionLabelExtraPositionOffset = CGPointMake(0, -0.5);
    
    // Dismiss the keyboard when the user taps outside of a text field
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer * __unused)sender {
    [self.emailTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

@end
