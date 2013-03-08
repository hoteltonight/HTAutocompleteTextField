//
//  HTEmailAutocompleteTextField.h
//  HTTextFieldAutocompletionExample
//
//  Created by Jonathan Sibley on 2/27/13.
//  Copyright (c) 2013 Hotel Tonight. All rights reserved.
//

#import "HTAutocompleteTextField.h"

@interface HTEmailAutocompleteTextField : HTAutocompleteTextField <HTAutocompleteDataSource>

/*
 * A list of email domains to suggest
 */
@property (nonatomic, copy) NSArray *emailDomains; // modify to use your own custom list of email domains

@end
