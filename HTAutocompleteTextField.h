//
//  HTAutocompleteTextField.h
//  HotelTonight
//
//  Created by Jonathan Sibley on 11/29/12.
//  Inspired by DOAutocompleteTextField by DoAT.
//
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTDelegateProxy.h"

@class  HTAutocompleteTextField;

@protocol HTAutocompleteDataSource <UITextFieldDelegate>

- (NSString*)textField:(HTAutocompleteTextField*)textField
   completionForPrefix:(NSString*)prefix
            ignoreCase:(BOOL)ignoreCase;

@end

@interface HTAutocompleteTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, strong) NSString *autocompleteString;
@property (nonatomic, strong) UIColor *autocompleteTextColor;
@property (nonatomic, assign) NSUInteger autocompleteType;
@property (nonatomic, assign) BOOL autocompleteDisabled;
@property (nonatomic, assign) BOOL ignoreCase;
@property (nonatomic, assign) CGPoint autocompleteTextOffset;

// autocompleteDataSource takes precedence over the GlobalDataSource setting
@property (nonatomic, assign) id autocompleteDataSource;

- (void)setDelegates:(NSArray *)delegates;
- (void)commitAutocompleteText;

// DefaultDataSource will be overridden if autocompleteDataSource is set.
+ (void)setDefaultAutocompleteDataSource:(id)dataSource;

// Override this method in a subclass to alter the position of the autocomplete text
- (CGRect)autocompleteRectForBounds:(CGRect)bounds;

@end