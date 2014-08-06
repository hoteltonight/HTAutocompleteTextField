//
//  HTSampleFieldsTableViewController.h
//  HTTextFieldAutocompletionExample
//
//  Created by Jonathan Sibley on 12/26/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"
#import "HTEmailAutocompleteTextField.h"
#import "HTAddressAutocompleteTextField.h"

@interface HTSampleFieldsTableViewController : UITableViewController <UITextFieldDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet HTAddressAutocompleteTextField *addressField;
@property (unsafe_unretained, nonatomic) IBOutlet HTEmailAutocompleteTextField *emailTextField;
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *nameTextField;
@property (unsafe_unretained, nonatomic) IBOutlet HTEmailAutocompleteTextField *asyncEmailTextField;
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *asyncNameTextField;
@end
