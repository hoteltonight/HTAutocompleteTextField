//
//  HTViewController.h
//  HTTextFieldAutocompletionExample
//
//  Created by Jonathan Sibley on 12/26/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"

@interface HTViewController : UIViewController <UITextFieldDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *emailTextField;
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *favoriteColorTextField;

@end
