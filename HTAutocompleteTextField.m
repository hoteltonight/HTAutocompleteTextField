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

static NSObject<HTAutocompleteDataSource> *DefaultAutocompleteDataSource = nil;

@interface HTAutocompleteTextField ()

@property (nonatomic, strong) NSString *autocompleteString;

@end

@implementation HTAutocompleteTextField

@class HTAutocompleteTextFieldDelegate;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setupAutocompleteTextField];
    }
    return self;
}

- (void)awakeFromNib
{
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
    [self addSubview:self.autocompleteLabel];
    [self bringSubviewToFront:self.autocompleteLabel];

    self.autocompleteString = @"";

    self.ignoreCase = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self];

    self.delegate = self;
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
    if ([self clearsOnBeginEditing]) 
    {
        self.autocompleteLabel.text = @"";
    }
    
    self.autocompleteLabel.hidden = NO;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    self.autocompleteLabel.hidden = YES;

    [self commitAutocompleteText];

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

- (void)textDidChange:(NSNotification*)notification
{
    if (self.autocompleteDisabled == NO)
    {
        id <HTAutocompleteDataSource> dataSource = nil;

        if ([self.autocompleteDataSource respondsToSelector:@selector(textField:completionForPrefix:ignoreCase:)])
        {
            dataSource = (id <HTAutocompleteDataSource>)self.delegate;
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

- (void)updateAutocompleteLabel
{
    [self.autocompleteLabel setText:self.autocompleteString];
    [self.autocompleteLabel sizeToFit];
    [self.autocompleteLabel setFrame: [self autocompleteRectForBounds:self.bounds]];
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

@end
