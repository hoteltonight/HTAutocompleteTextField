//
//  HTAddressAutocompleteTextField.m
//  HTTextFieldAutocompletionExample
//
//  Created by Kav Latiolais on 8/4/14.
//  Copyright (c) 2014 Hotel Tonight. All rights reserved.
//
const CGFloat kFetchDelay = 1;
const NSInteger kBeginRemoteCompletingAfter = 3;

//Need to add your own Classes/apiKeys.h that defines:
//const NSString *kGoogleKey = @"<Your Google Key>";

#import "apiKeys.h"

#import "HTAddressAutocompleteTextField.h"
@interface HTAddressAutocompleteTextField ()
@property (nonatomic, strong) NSURLSessionDataTask *fetchAddressSuggestionTask;
@property (nonatomic, strong) NSOrderedSet *predictions;
@property (nonatomic, strong) NSTimer *fetchDelayTimer;
@end

@implementation HTAddressAutocompleteTextField

-(void)setupAutocompleteTextField {
    [super setupAutocompleteTextField];

    _predictions = [[NSMutableOrderedSet alloc] init];
    _fetchDelayTimer = [[NSTimer alloc] initWithFireDate:nil interval:0 target:self selector:@selector(fetchData) userInfo:nil repeats:NO];
    self.autocompleteDataSource = self;
}
-(void) fetchData{
    if(self.fetchAddressSuggestionTask.state == NSURLSessionTaskStateSuspended){
        [self.fetchAddressSuggestionTask resume];
    }
    _fetchDelayTimer = [[NSTimer alloc] initWithFireDate:nil interval:0 target:self selector:@selector(fetchData) userInfo:nil repeats:NO];
}

#pragma mark - HTAutocompleteTextFieldDataSource
- (BOOL)textFieldShouldReplaceCompletion:(HTAutocompleteTextField*)textField{
    return YES;
}
- (void)textField:(HTAutocompleteTextField *)textField asyncCompletionForPrefix:(NSString *)prefix ignoreCase:(BOOL)ignoreCase completionHandler:(void (^)(NSString *))completionHandler {
    if (prefix.length == 0) {
        return completionHandler(@"");
    }
    NSString *locallySavedAddress;
    if ([self.predictions count] > 0) {
        locallySavedAddress = [self checkLocalForAddress:prefix];
    }

    if (locallySavedAddress) {
        return completionHandler(locallySavedAddress);
    } else {
        if (prefix.length > kBeginRemoteCompletingAfter) {
            if(self.fetchAddressSuggestionTask) {
                [self.fetchAddressSuggestionTask cancel];
                self.fetchAddressSuggestionTask = nil;
            }

            NSString *encodedPrefix = [prefix stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


            NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&components=country:US&key=%@", encodedPrefix, kGoogleKey];

            NSURL *url = [NSURL URLWithString:urlString];
            self.fetchAddressSuggestionTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if(!error) {
                    NSError *jsonError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                    NSArray *predictions = json[@"predictions"];
                    NSString *address = @"";
                    if(predictions.count > 0){
                        address = predictions[0][@"description"];
                        address = [address stringByReplacingOccurrencesOfString:@", United States" withString:@""];
                    }

                    [self addToCache:json forPrefix:prefix];

                    return completionHandler(address);
                }
            }];
            self.fetchAddressSuggestionTask.taskDescription = prefix;
            [self.fetchDelayTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kFetchDelay]];
            [[NSRunLoop currentRunLoop] addTimer:self.fetchDelayTimer forMode:NSDefaultRunLoopMode];
        }
    }
}
-(BOOL)textFieldShouldReplaceCompletionText:(HTAutocompleteTextField *)textField {
    return YES;
}
- (void) addToCache:(NSDictionary *)predictionsDictionary forPrefix:(NSString *)prefix{
    NSArray *addresses = predictionsDictionary[@"predictions"];
    NSMutableOrderedSet *predictions = self.predictions.mutableCopy;
    for (int i = 0; i < addresses.count; i++) {

        NSDictionary *location = addresses[i];
        NSArray *locationTypes = location[@"types"];
        NSArray *matchedSubstrings = location[@"matched_substrings"];

        if(![locationTypes containsObject:@"street_address"]) break;
        if(![matchedSubstrings containsObject:@{@"length": @(prefix.length), @"offset": @(0)}]) break;

        NSString *title = location[@"description"];
        title = [title stringByReplacingOccurrencesOfString:@", United States" withString:@""];
        NSNumber *rank = @(prefix.length*10 + i);
        [predictions addObject:@{@"title":title, @"rank":rank}];
    }
    NSSortDescriptor *rankSort = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES];
    [predictions sortUsingDescriptors:@[rankSort]];
    self.predictions = predictions;
}

- (NSString *)checkLocalForAddress:(NSString *)prefix {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title BEGINSWITH %@", prefix];

    NSOrderedSet *completions = [self.predictions filteredOrderedSetUsingPredicate:predicate];
    if(completions.count > 0 ){
        return completions[0][@"title"];
    }
    return nil;
}

@end
