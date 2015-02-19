//
//  HTAutocompleteTextField.h
//  HotelTonight
//
//  Created by Jonathan Sibley on 11/29/12.
//  Inspired by DOAutocompleteTextField by DoAT.
//
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

@import UIKit;

@class  HTAutocompleteTextField;

@protocol HTAutocompleteSuggestionDataSource <NSObject>

- (NSString*)textField:(HTAutocompleteTextField*)textField completionForPrefix:(NSString*)prefix;

@end

@protocol HTAutocompleteTextFieldDelegate <NSObject>

@optional
- (void)autocompleteTextFieldSuggestionTextWasAccepted:(HTAutocompleteTextField *)autoCompleteField;
- (void)autocompleteTextField:(HTAutocompleteTextField *)autocompleteTextField didChangeSuggestionText:(NSString *)suggestionText;

@end

@interface HTAutocompleteTextField : UITextField

/*
 * Designated programmatic initializer (also compatible with Interface Builder)
 */
- (id)initWithFrame:(CGRect)frame;

/*
 * Configure how suggestions are made
 */
@property (nonatomic) BOOL suggestionsDisabled;
@property (nonatomic, weak) id<HTAutocompleteTextFieldDelegate> autocompleteTextFieldDelegate;

/*
 * Configure text field appearance
 */
@property (nonatomic, readonly) UILabel *suggestionLabel;
@property (nonatomic) CGPoint suggestionLabelExtraPositionOffset;

/*
 * Specify a data source responsible for determining autocomplete text.
 */
@property (nonatomic) id<HTAutocompleteSuggestionDataSource> suggestionDataSource;

/*
 * Subclassing:
 */
- (CGRect)suggestionLabelRectForBounds:(CGRect)bounds; // Override to alter the position of the suggestion text
- (void)setupAutocompleteTextField; // Override to perform setup tasks.  Don't forget to call super!

@end
