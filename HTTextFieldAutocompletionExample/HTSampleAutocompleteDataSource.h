//
//  HTAutocompleteManager.h
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

@import Foundation;
#import "HTAutocompleteTextField.h"

typedef enum {
    HTAutocompleteTypeEmail, // Default
    HTAutocompleteTypeColor,
} HTAutocompleteType;

@interface HTSampleAutocompleteDataSource : NSObject <HTAutocompleteSuggestionDataSource>

@end
