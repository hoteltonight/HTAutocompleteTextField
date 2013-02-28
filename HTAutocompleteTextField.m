//
//  HTAutocompleteTextField.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 11/29/12.
//  Inspired by DOAutocompleteTextField by DoAT.
//
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTAutocompleteTextField.h"

#define kHTAutoCompleteButtonWidth  30

static NSObject<HTAutocompleteDataSource> *DefaultAutocompleteDataSource = nil;

@interface HTAutocompleteTextField ()

@property (nonatomic, strong) NSString *autocompleteString;
@property (nonatomic, strong) UIButton *autocompleteButton;


@end

@implementation HTAutocompleteTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _multiRecognitionEnabled = NO;
        [self setupAutocompleteTextField];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupAutocompleteTextField];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
}

- (void)setupAutocompleteTextField
{
    self.autocompleteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.autocompleteLabel.font = self.font;
    self.autocompleteLabel.backgroundColor = [UIColor clearColor];
    self.autocompleteLabel.textColor = [UIColor lightGrayColor];
    self.autocompleteLabel.lineBreakMode = UILineBreakModeClip;
    self.autocompleteLabel.hidden = YES;
    [self addSubview:self.autocompleteLabel];
    [self bringSubviewToFront:self.autocompleteLabel];
    
    self.autocompleteString = @"";
    
    self.ignoreCase = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ht_textDidChange:) name:UITextFieldTextDidChangeNotification object:self];
}

#pragma mark - Configuration

+ (void)setDefaultAutocompleteDataSource:(id)dataSource
{
    DefaultAutocompleteDataSource = dataSource;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self.autocompleteLabel setFont:font];
}

#pragma mark - UIResponder

- (BOOL)becomeFirstResponder
{
    // This is necessary because the textfield avoids tapping the autocomplete Button
    [self bringSubviewToFront:_autocompleteButton];
    if (!self.autocompleteDisabled)
    {
        if ([self clearsOnBeginEditing])
        {
            self.autocompleteLabel.text = @"";
        }
        
        self.autocompleteLabel.hidden = NO;
    }
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if (!self.autocompleteDisabled)
    {
        self.autocompleteLabel.hidden = YES;
        
        [self commitAutocompleteText];
        
        // This is necessary because committing the autocomplete text changes the text field's text, but for some reason UITextField doesn't post the UITextFieldTextDidChangeNotification notification on its own
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification
                                                            object:self];
    }
    return [super resignFirstResponder];
}

#pragma mark - Autocomplete Logic

- (CGRect)autocompleteRectForBounds:(CGRect)bounds
{
    CGRect returnRect = CGRectZero;
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    CGSize prefixTextSize = [self.text sizeWithFont:self.font
                                  constrainedToSize:textRect.size
                                      lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGSize autocompleteTextSize = [self.autocompleteString sizeWithFont:self.font
                                                      constrainedToSize:CGSizeMake(textRect.size.width-prefixTextSize.width, textRect.size.height)
                                                          lineBreakMode:UILineBreakModeCharacterWrap];
    
    returnRect = CGRectMake(textRect.origin.x + prefixTextSize.width + self.autocompleteTextOffset.x,
                            textRect.origin.y + self.autocompleteTextOffset.y,
                            autocompleteTextSize.width,
                            textRect.size.height);
    
    return returnRect;
}

- (void)ht_textDidChange:(NSNotification*)notification
{
    if (self.text.length == 0 || self.text.length == 1) [self refreshAutocompleteButtonPositionAnimated:YES];
    [self refreshAutocompleteText];
}

- (void)updateAutocompleteLabel
{
    [self.autocompleteLabel setText:self.autocompleteString];
    [self.autocompleteLabel sizeToFit];
    [self.autocompleteLabel setFrame: [self autocompleteRectForBounds:self.bounds]];
}

- (void)refreshAutocompleteText
{
    if (!self.autocompleteDisabled)
    {
        id <HTAutocompleteDataSource> dataSource = nil;
        
        if ([self.autocompleteDataSource respondsToSelector:@selector(textField:completionForPrefix:ignoreCase:)])
        {
            dataSource = (id <HTAutocompleteDataSource>)self.autocompleteDataSource;
        }
        else if ([DefaultAutocompleteDataSource respondsToSelector:@selector(textField:completionForPrefix:ignoreCase:)])
        {
            dataSource = DefaultAutocompleteDataSource;
        }
        
        if (dataSource)
        {
            self.autocompleteString = [dataSource textField:self completionForPrefix:self.text ignoreCase:self.ignoreCase];
            
            [self updateAutocompleteLabel];
        }
    }
}

- (void)commitAutocompleteText
{
    if ([self.autocompleteString isEqualToString:@""] == NO
        && self.autocompleteDisabled == NO)
    {
        self.text = [NSString stringWithFormat:@"%@%@", self.text, self.autocompleteString];
        
        self.autocompleteString = @"";
        [self updateAutocompleteLabel];
    }
}

- (void)forceRefreshAutocompleteText
{
    [self refreshAutocompleteText];
}

#pragma mark - Setters

// To show/hide the autocompleteButton
- (void)setMultiRecognitionEnabled:(BOOL)multiRecognitionEnabled {
    _multiRecognitionEnabled = multiRecognitionEnabled;
    if (!self.autocompleteButton) {
        self.autocompleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.autocompleteButton.frame = [self frameForAutocompleteButton];
        [self.autocompleteButton addTarget:self action:@selector(autocompleteText:) forControlEvents:UIControlEventTouchUpInside];
        [self.autocompleteButton setImage:[UIImage imageNamed:@"autocompleteButton"] forState:UIControlStateNormal];
        
        [self addSubview:self.autocompleteButton];
        [self bringSubviewToFront:self.autocompleteButton];
    }
    self.autocompleteButton.hidden = !_multiRecognitionEnabled;
}

#pragma mark - Private Methods

- (CGRect)frameForAutocompleteButton {
    CGRect autocompletionButtonRect;
    if (self.clearButtonMode == UITextFieldViewModeNever || self.text.length == 0)
        autocompletionButtonRect = CGRectMake(self.bounds.size.width - kHTAutoCompleteButtonWidth, (self.bounds.size.height/2) - (self.bounds.size.height-8)/2, kHTAutoCompleteButtonWidth, self.bounds.size.height-8);
    else
        autocompletionButtonRect = CGRectMake(self.bounds.size.width - 25 - kHTAutoCompleteButtonWidth, (self.bounds.size.height/2) - (self.bounds.size.height-8)/2, kHTAutoCompleteButtonWidth, self.bounds.size.height-8);
    return autocompletionButtonRect;
}

// Method fired by autocompleteButton for multiRecognition
- (void)autocompleteText:(id)sender {
    if (!self.autocompleteDisabled)
    {
        self.autocompleteLabel.hidden = NO;
        
        [self commitAutocompleteText];
        
        // This is necessary because committing the autocomplete text changes the text field's text, but for some reason UITextField doesn't post the UITextFieldTextDidChangeNotification notification on its own
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification
                                                            object:self];
    }
}

- (void)refreshAutocompleteButtonPositionAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.15f animations:^{
            self.autocompleteButton.frame = [self frameForAutocompleteButton];
        }];
        return;
    }
    self.autocompleteButton.frame = [self frameForAutocompleteButton];
}

@end
