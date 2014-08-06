//
//  HTAsyncAutocompleteManager.h
//  HTTextFieldAutocompletionExample
//
//  Created by Kav Latiolais on 8/6/14.
//  Copyright (c) 2014 LIFFFT.
//


#import <Foundation/Foundation.h>
#import "HTAutocompleteTextField.h"

@interface HTAsyncAutocompleteManager : NSObject <HTAutocompleteDataSource>

+ (HTAsyncAutocompleteManager *)sharedManager;

@end
