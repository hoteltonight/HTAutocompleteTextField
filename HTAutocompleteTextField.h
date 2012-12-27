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

@protocol HTAutocompleteDataSource <NSObject>

- (NSString*)textField:(HTAutocompleteTextField*)textField
   completionForPrefix:(NSString*)prefix
            ignoreCase:(BOOL)ignoreCase;

@end

@interface HTAutocompleteTextField : UITextField <UITextFieldDelegate>

/*
 * Designated programmatic initializer (also compatible with Interface Builder)
 */
- (id)initWithFrame:(CGRect)frame;

/*
 * Autocomplete behavior
 */
@property (nonatomic, assign) NSUInteger autocompleteType;
@property (nonatomic, assign) BOOL autocompleteDisabled;
@property (nonatomic, assign) BOOL ignoreCase;

/*
 * Configure text field appearance
 */
@property (nonatomic, strong) UILabel *autocompleteLabel;
- (void)setFont:(UIFont *)font;
@property (nonatomic, assign) CGPoint autocompleteTextOffset;

/*
 * Specify a data source responsible for determining autocomplete text.
 */
@property (nonatomic, assign) id<HTAutocompleteDataSource> autocompleteDataSource;
+ (void)setDefaultAutocompleteDataSource:(id<HTAutocompleteDataSource>)dataSource;

/*
 * Specify one or more objects as delegates that conform to UITextFieldDelegate.
 */
- (void)setDelegate:(id<UITextFieldDelegate>)delegate;
- (void)setDelegates:(NSArray *)delegates;

/*
 * Subclassing: override this method to alter the position of the autocomplete text
 */
- (CGRect)autocompleteRectForBounds:(CGRect)bounds;

@end