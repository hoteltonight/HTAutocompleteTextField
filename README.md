<img src="https://raw.github.com/hoteltonight/HTAutocompleteTextField/master/ht-logo-black.png" alt="HotelTonight" title="HotelTonight" style="display:block; margin: 10px auto 30px auto;">

# HTAutocompleteTextField

[![Build Status](https://travis-ci.org/hoteltonight/HTAutocompleteTextField.svg?branch=master)](https://travis-ci.org/hoteltonight/HTAutocompleteTextField)

## Overview

HTAutocompleteTextField is a subclass of UITextField that automatically displays text suggestions in real-time.  This is perfect for automatically suggesting the domain as a user types an email address.

You can see it in action in the animated gif below or on [Youtube](http://youtu.be/lzqB4MXluvY), or read about it in the accompanying [blog post](http://engineering.hoteltonight.com/lets-stop-making-our-users-type-gmailcom) on the HotelTonight [Engineering Blog](http://engineering.hoteltonight.com/):

<img src="https://raw.github.com/hoteltonight/HTAutocompleteTextField/master/demo.gif" alt="HotelTonight" title="HTAutocompleteTextField in action" style="display:block; margin: 10px auto 30px auto; align:center">

# Usage

## Installation

### Cocoapods:
`pod 'HTAutocompleteTextField'`

### Otherwise, manually add these files to your project
* `HTAutocompleteTextField.m`
* `HTAutocompleteTextField.h`

and optionally:

* `HTEmailAutocompleteTextField.m`
* `HTEmailAutocompleteTextField.h`

## Supporting Email Domain Suggestion

To suggest domains such as `gmail.com` when a user types `xxx@`, you'll want to create an instance of `HTEmailAutocompleteTextField` (which is a subclass of `HTAutocompleteTextField`).

## Supporting General Text Suggestion

Create an instance of `HTAutocompleteTextField` and set its `suggestionDataSource` to an object that conforms to the `HTAutocompleteSuggestionDataSource` protocol.
    
## Contribution Guidelines

As of `2.0`, this project is only accepting contributions with non-functional changes. In other words: bug fixes, updates to support future versions of iOS, and refactorings.

## Use it? Love/hate it?

Tweet the author @jonsibs, and check out HotelTonight's engineering blog: http://engineering.hoteltonight.com

Also, check out HotelTonight's other iOS open source:
* https://github.com/hoteltonight/HTAutocompleteTextField
* https://github.com/hoteltonight/HTGradientEasing
* https://github.com/hoteltonight/HTStateAwareRasterImageView
* https://github.com/hoteltonight/HTDelegateProxy
