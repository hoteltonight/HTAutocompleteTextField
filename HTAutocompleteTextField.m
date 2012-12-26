 /* 
 * Copyright 2011 DoAT. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, 
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation and/or
 *    other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY DoAT “AS IS” WITHOUT ANY WARRANTIES WHATSOEVER. 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF NON INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A 
 * PARTICULAR PURPOSE ARE HEREBY DISCLAIMED. IN NO EVENT SHALL DoAT OR CONTRIBUTORS 
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are those of 
 * the authors and should not be interpreted as representing official policies, 
 * either expressed or implied, of DoAT.
 */

#import "HTAutocompleteTextField.h"

static id <HTAutocompleteDataSource> DefaultAutocompleteDataSource = nil;

@interface HTAutocompleteTextField ()
@property (nonatomic, strong) UILabel *autocompleteLabel;
@property (nonatomic, strong) HTDelegateProxy *delegateProxy;
@end

@implementation HTAutocompleteTextField

@class HTAutocompleteTextFieldDelegate;

@dynamic autocompleteTextColor;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
}

- (void)setup
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
}

+ (void)setDefaultAutocompleteDataSource:(id)dataSource
{
    DefaultAutocompleteDataSource = dataSource;
}

#pragma mark - Properties

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    [self setDelegates:@[delegate]];
}

- (void)setDelegates:(NSArray *)delegates
{
    NSMutableArray *combinedDelegates = [NSMutableArray arrayWithArray:delegates];

    if (![delegates containsObject:self])
    {
        [combinedDelegates addObject:self];
    }

    if (self.autocompleteDataSource)
    {
        [combinedDelegates addObject:self.autocompleteDataSource];
    }
    
    self.delegateProxy = [[HTDelegateProxy alloc] init];
    [self.delegateProxy setDelegates:combinedDelegates];
    [super setDelegate:(id)self.delegateProxy];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self.autocompleteLabel setFont:font];
}

- (void)setAutocompleteTextColor:(UIColor*)color
{
    self.autocompleteLabel.textColor = color;
}

- (UIColor*)autocompleteTextColor
{
    return self.autocompleteLabel.textColor;
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

        if ([self.delegate respondsToSelector:@selector(textField:completionForPrefix:ignoreCase:)])
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [(HTAutocompleteTextField *)textField commitAutocompleteText];
}

@end
