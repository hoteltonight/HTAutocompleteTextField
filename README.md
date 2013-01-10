<img src="https://raw.github.com/hoteltonight/HTAutocompleteTextField/master/ht-logo-black.png" alt="HotelTonight" title="HotelTonight" style="display:block; margin: 10px auto 30px auto;">

# HTAutocompleteTextField

## Overview

HTAutocompleteTextField is a subclass of UITextField that automatically displays text suggestions in real-time on the text the user has entered.  This is perfect for automatically suggesting the domain as a user types an email address.

You can see HTAutocompleteTextField in action in the animated gif below or on [Youtube](http://youtu.be/lzqB4MXluvY):

<img src="https://raw.github.com/hoteltonight/HTAutocompleteTextField/master/demo.gif" alt="HotelTonight" title="HTAutocompleteTextField in action" style="display:block; margin: 10px auto 30px auto; align:center">

# Usage

## Quickstart Guide

Add HTAutocompleteTextField.m and HTAutocompleteTextField.h to your project.  To install via cocoapods:

    pod 'HTAutocompleteTextField'

Create an `HTAutocompleteTextField` instance exactly as as you would `UITextField`.  You can do eith either programmitcally or in Interface Builder.  Programmatically, this looks like:

    HTAutocompleteTextField *textField = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake(0,0,100,31)];

The data source is the brains of the autocomplete logic:.  Set the `dataSource` to an object that conforms to the `HTAutocompleteDataSource` protocol.  For autocompleting email addresses, use  `HTAutocompleteManager` from the example project.

    id<HTAutocompleteTextFieldDelegate> dataSource = [MyAutocompleteDataSource alloc] init];
    textField.dataSource = dataSource;

## Customization

### Autocompletion Data Source

 A `HTAutocompleteTextFields`'s data source must implement the following method, as part of the `HTAutocompleteDataSource` protocol:

    - (NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix

 `HTAutocompleteManager` (included in the example project) provies email address suggestions out of the box.  Feel free to repurpose this class for your own use.  You may want to write autocomplete logic for a different type of text field (in the demo, names of colors are autocompleted), or simply modify the list of email domains used in the email address autocomplete logic.

 You may also set a default `dataSource` for all instances of `HTAutocompleteTextField`.  In the example project, we use a `HTAutocompleteManager` singleton:

     [autocompleteTextOffset setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];

### Positioning and Formatting

To adjust the position of the autocomplete label by a fixed amount, set `autocompleteTextOffset`:

    textField.autocompleteTextOffset = CGPointMake(10.0, 10.0);

For more dynamic positioning of the autocomplete label, subclass `HTAutocompleteTextField` and override `- (CGRect)autocompleteRectForBounds:(CGRect)bounds`.

To adjust the properties (i.e. `font`, `textColor`) of the autocomplete label, do so via the `[AutocompleteTextField autocompleteLabel] property.

    textField.autocompleteLabel.textColor = [UIColor grayColor];
