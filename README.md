<img src="https://raw.github.com/hoteltonight/HTAutocompleteTextField/master/ht-logo-black.png" alt="HotelTonight" title="HotelTonight" style="display:block; margin: 10px auto 30px auto;">

#HTAutocompleteTextField
===========================

## Overview

HTAutocompleteTextField is a subclass of UITextField that automatically displays text suggestions in real-time on the text the user has entered.

![HTAutocompleteTextField Demo](https://raw.github.com/hoteltonight/HTAutocompleteTextField/master/demo.gif)

## Usage

### Quickstart Guide

Add HTAutocompleteTextField.m and HTAutocompleteTextField.h to your project.  To install via cocoapods:

    pod 'HTStateAwareRasterImageView'

Create an instance of it as you would a UITextField:

    HTAutocompleteTextField *textField = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake(0,0,100,31)];

Provide your HTAutocompleteTextField with a data source to provide autocomplete suggestions.  To do so, set the `dataSource` to an object that conforms to the `HTAutocompleteDataSource` protocol.

    id<HTAutocompleteTextFieldDelegate> dataSource = [MyAutocompleteDataSource alloc] init];
    textField.dataSource = dataSource;

 ### Customization

 ## The Data Source

 A `HTAutocompleteTextFields`'s data source must implement the following method, as part of the `HTAutocompleteDataSource` protocol:

    - (NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix

 `HTAutocompleteManager`, included in the example project, will provide email address suggestions as shown in the demo.  Feel free to repurpose this class for your own use.  You might want to write autocomplete logic for a different type of text field (in the demo, color names are autocompleted) or simply modify the list of email domains.

 You may also use `+ (void)setDefaultAutocompleteDataSource:(id<HTAutocompleteDataSource>)dataSource` to set a default `dataSource` for all instances of `HTAutocompleteTextField`.

## Positioning and Formatting

To adjust the position of the autocomplete label by a fixed amount, set `[HTAutocompleteTextField autocompleteTextOffset]`.  For more advanced positioning of the autocomplete label, subclass `HTAutocompleteTextField` and override `- (CGRect)autocompleteRectForBounds:(CGRect)bounds`.

To adjust the properties (i.e. `font`, `textColor`) of the autocomplete label, do so via the `[AutocompleteTextField autocompleteLabel] property.

