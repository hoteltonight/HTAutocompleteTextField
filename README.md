<img src="https://raw.github.com/hoteltonight/HTAutocompleteTextField/master/ht-logo-black.png" alt="HotelTonight" title="HotelTonight" style="display:block; margin: 10px auto 30px auto;">

# HTAutocompleteTextField

## Overview

HTAutocompleteTextField is a subclass of UITextField that automatically displays text suggestions in real-time on the text the user has entered.  This is perfect for automatically suggesting the domain as a user types an email address.

You can see it in action in the animated gif below or on [Youtube](http://youtu.be/lzqB4MXluvY), or read about it in the accompanying [blog post](http://engineering.hoteltonight.com/lets-stop-making-our-users-type-gmailcom) on the HotelTonight [Engineering Blog](http://engineering.hoteltonight.com/):

<img src="https://raw.github.com/hoteltonight/HTAutocompleteTextField/master/demo.gif" alt="HotelTonight" title="HTAutocompleteTextField in action" style="display:block; margin: 10px auto 30px auto; align:center">

# Usage

## Installation

Either add HTAutocompleteTextField.m and HTAutocompleteTextField.h to your project, or install via cocoapods:

    pod 'HTAutocompleteTextField'

## Quickstart Guide

Create an `HTAutocompleteTextField` instance exactly as as you would `UITextField`.  You can do eith either programmitcally or in Interface Builder.  Programmatically, this looks like:

    HTAutocompleteTextField *textField = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake(0,0,100,31)];

The data source is the brains of the autocomplete logic.  If you simply want to autocomplete email addresses, use `HTAutocompleteManager` from the example project as follows:

    textField.dataSource = [HTAutocompleteManager sharedManager];
    textField.autocompleteType = HTAutocompleteTypeEmail;

## Customization

### Autocompletion Data Source

`HTAutocompleteManager` (included in the example project) provides email address autocompletion out of the box.  Feel free to repurpose this class for your own use.  You may want to write autocomplete logic for a different type of text field (in the demo, names of colors are autocompleted), or simply modify the list of email domains used in the email address autocomplete logic.

Alternatively, you may wish to create your own data source class and user the `autocompleteType` property to differentiate between fields with different data types.  A `HTAutocompleteTextFields`'s data source must implement the following method, as part of the `HTAutocompleteDataSource` protocol.

    - (NSString *)textField:(HTAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix

You may also set a default `dataSource` for all instances of `HTAutocompleteTextField`.  In the example project, we use a `HTAutocompleteManager` singleton:

     [autocompleteTextOffset setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];

### Positioning and Formatting

To adjust the position of the autocomplete label by a fixed amount, set `autocompleteTextOffset`:

    textField.autocompleteTextOffset = CGPointMake(10.0, 10.0);

For more dynamic positioning of the autocomplete label, subclass `HTAutocompleteTextField` and override `- (CGRect)autocompleteRectForBounds:(CGRect)bounds`.

To adjust the properties (i.e. `font`, `textColor`) of the autocomplete label, do so via the `[AutocompleteTextField autocompleteLabel] property.

    textField.autocompleteLabel.textColor = [UIColor grayColor];
    
# Etc.

* Use this in your apps whenever you can, particularly email addresses -- your users will appreciate it!
* Contributions are very welcome.
* Attribution is appreciated (let's spread the word!), but not mandatory.
