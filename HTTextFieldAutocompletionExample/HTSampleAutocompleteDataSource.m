//
//  HTAutocompleteManager.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTSampleAutocompleteDataSource.h"

static HTSampleAutocompleteDataSource *sharedManager;

@implementation HTSampleAutocompleteDataSource

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(HTAutocompleteTextField * __unused)textField
    completionForPrefix:(NSString *)prefix
{
    static BOOL const IgnoreCase = YES;
    
    static dispatch_once_t colorOnceToken;
    static NSArray *colorAutocompleteArray;
    dispatch_once(&colorOnceToken, ^ {
        colorAutocompleteArray = @[ @"Alfred",
                                    @"Beth",
                                    @"Carlos",
                                    @"Daniel",
                                    @"Ethan",
                                    @"Fred",
                                    @"George",
                                    @"Helen",
                                    @"Inis",
                                    @"Jennifer",
                                    @"Kylie",
                                    @"Liam",
                                    @"Melissa",
                                    @"Noah",
                                    @"Omar",
                                    @"Penelope",
                                    @"Quan",
                                    @"Rachel",
                                    @"Seth",
                                    @"Timothy",
                                    @"Ulga",
                                    @"Vanessa",
                                    @"William",
                                    @"Xao",
                                    @"Yilton",
                                    @"Zander"];
    });
    
    NSString *stringToLookFor;
    NSArray *componentsString = [prefix componentsSeparatedByString:@","];
    NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (IgnoreCase)
    {
        stringToLookFor = [prefixLastComponent lowercaseString];
    }
    else
    {
        stringToLookFor = prefixLastComponent;
    }
    
    for (NSString *stringFromReference in colorAutocompleteArray)
    {
        NSString *stringToCompare;
        if (IgnoreCase)
        {
            stringToCompare = [stringFromReference lowercaseString];
        }
        else
        {
            stringToCompare = stringFromReference;
        }
        
        if ([stringToCompare hasPrefix:stringToLookFor])
        {
            return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
        }
        
    }
    
    return @"";
}

@end
