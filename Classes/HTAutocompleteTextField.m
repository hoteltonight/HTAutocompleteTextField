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

@interface HTAutocompleteTextField ()

@property (nonatomic, readwrite) NSString *suggestionString;
@property (nonatomic, readwrite) UILabel *suggestionLabel;

- (CGRect)suggestionLabelRectForBounds:(CGRect)bounds;
- (void)ht_textDidChangeNotificationFired:(NSNotification *)notification;
- (void)updateSuggestionLabel;
- (void)refreshSuggestionText;
- (void)acceptSuggestionText;

@end

@implementation HTAutocompleteTextField

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];

  if (self) {
    [self setupAutocompleteTextField];
  }

  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];

  [self setupAutocompleteTextField];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UITextFieldTextDidChangeNotification
                                                object:self];
}

- (void)setupAutocompleteTextField {
  self.suggestionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.suggestionLabel.font = self.font;
  self.suggestionLabel.backgroundColor = [UIColor clearColor];
  self.suggestionLabel.textColor = [UIColor lightGrayColor];
  self.suggestionLabel.lineBreakMode = NSLineBreakByClipping;
  self.suggestionLabel.hidden = YES;
  [self addSubview:self.suggestionLabel];
  [self bringSubviewToFront:self.suggestionLabel];

  self.suggestionString = @"";

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(ht_textDidChangeNotificationFired:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:self];
}

#pragma mark - Configuration
- (void)setFont:(UIFont *)font {
  [super setFont:font];

  self.suggestionLabel.font = font;
}

#pragma mark - UIResponder
- (BOOL)becomeFirstResponder {
  if (!self.suggestionsDisabled) {
    if ([self clearsOnBeginEditing]) {
      self.suggestionLabel.text = @"";
    }

    self.suggestionLabel.hidden = NO;
  }

  return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
  if (!self.suggestionsDisabled) {
    self.suggestionLabel.hidden = YES;

    [self acceptSuggestionText];
  }

  return [super resignFirstResponder];
}

#pragma mark - Autocomplete Logic
- (CGRect)suggestionLabelRectForBounds:(CGRect __unused)bounds {
  CGRect returnRect = CGRectZero;
  CGRect textContainerBounds = [self textRectForBounds:self.bounds];
  UITextRange *textRange = [self textRangeFromPosition:self.beginningOfDocument
                                            toPosition:self.endOfDocument];
  CGRect textRect = CGRectIntegral([self firstRectForRange:textRange]);
  NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
  paragraphStyle.lineBreakMode = self.suggestionLabel.lineBreakMode;

  CGRect prefixTextRect = [self.text boundingRectWithSize:textContainerBounds.size
                                                  options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                               attributes:@{NSFontAttributeName:self.font,
                                                            NSParagraphStyleAttributeName:paragraphStyle}
                                                  context:nil];
  CGSize prefixTextSize = prefixTextRect.size;

  CGRect suggestionTextRect = [self.suggestionString boundingRectWithSize:CGSizeMake(textContainerBounds.size.width - prefixTextSize.width, textContainerBounds.size.height)
                                                                  options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:self.suggestionLabel.font,
                                                                            NSParagraphStyleAttributeName:paragraphStyle}
                                                                  context:nil];
  CGSize suggestionTextSize = suggestionTextRect.size;

  returnRect = CGRectMake(CGRectGetMinX(textContainerBounds) + CGRectGetMaxX(textRect) + self.suggestionLabelExtraPositionOffset.x,
                          CGRectGetMinY(textContainerBounds) + self.suggestionLabelExtraPositionOffset.y,
                          suggestionTextSize.width,
                          textContainerBounds.size.height);

  return returnRect;
}

- (void)ht_textDidChangeNotificationFired:(NSNotification * __unused)notification {
  [self refreshSuggestionText];
}

- (void)updateSuggestionLabel {
  self.suggestionLabel.text = self.suggestionString;
  [self.suggestionLabel sizeToFit];
  self.suggestionLabel.frame = [self suggestionLabelRectForBounds:self.bounds];

  if ([self.autocompleteTextFieldDelegate respondsToSelector:@selector(autocompleteTextField:didChangeSuggestionText:)]) {
    [self.autocompleteTextFieldDelegate autocompleteTextField:self didChangeSuggestionText:self.suggestionString];
  }
}

- (void)refreshSuggestionText {
  if (self.suggestionsDisabled) {
    return;
  }


  id <HTAutocompleteSuggestionDataSource> dataSource;

  if ([self.suggestionDataSource respondsToSelector:@selector(textField:completionForPrefix:)]) {
    // Bind the weak var to a string var
    dataSource = (id <HTAutocompleteSuggestionDataSource>)self.suggestionDataSource;
  }

  if (dataSource) {
    self.suggestionString = [dataSource textField:self
                              completionForPrefix:self.text];

    [self updateSuggestionLabel];
  }
  else {
#if DEBUG
    NSLog(@"Note: a data source is required for HTAutocompleteTextField to suggest text");
#endif
  }

}

- (void)acceptSuggestionText {
  if ([self.suggestionString isEqualToString:@""] || self.suggestionsDisabled) {
    return;
  }

  self.text = [NSString stringWithFormat:@"%@%@", self.text, self.suggestionString];

  self.suggestionString = @"";
  [self updateSuggestionLabel];

  if ([self.autocompleteTextFieldDelegate respondsToSelector:@selector(autocompleteTextFieldSuggestionTextWasAccepted:)]) {
    [self.autocompleteTextFieldDelegate autocompleteTextFieldSuggestionTextWasAccepted:self];
  }

  // We must fire these events manually because programmatic changes to
  // self.text do not do so automatically
  [self sendActionsForControlEvents:UIControlEventEditingChanged];
  [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification
                                                      object:self];
}

@end
