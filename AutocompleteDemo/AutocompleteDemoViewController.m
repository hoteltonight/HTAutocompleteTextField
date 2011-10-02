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

#import "AutocompleteDemoViewController.h"

@implementation AutocompleteDemoViewController
@synthesize textField6;
@synthesize textField5;
@synthesize textField4;
@synthesize textField3;
@synthesize textField2;
@synthesize textField1;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - DOAutocompleteTextFieldDelegate
- (NSString *)textField:(DOAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix
{
    // This is a simple example of how to provide DOAutocomleteTextField with completions
    NSArray *autocompleteArray = [NSArray arrayWithObjects:
                                  @"thesaurus",
                                  @"the weather channel",
                                  @"DoAT",
                                  @"Doctor Who",
                                  @"Dachshunds are the best",
                                  @"ccccombo breaker",
                                  @"money",
                                  @"Mona lisa",
                                  @"Monalisa",
                                  @"mcdonalds",
                                  @"mc hammer", 
                                  @"long cat is looooooooooooooooooog",
                                  nil];
    
    for (NSString *string in autocompleteArray) 
    {
        if([string hasPrefix:prefix])
        {
            return [string stringByReplacingCharactersInRange:[prefix rangeOfString:prefix] withString:@""];
        }
        
    }
    
    return @"";
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    textField1.delegate = self;
    textField2.delegate = self;
    textField2.font = [UIFont systemFontOfSize:22]; // Autocomlete text adapts to font changes.
    textField3.delegate = self;
    textField3.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    textField3.leftViewMode = UITextFieldViewModeAlways;
    textField4.delegate = self;
    textField5.delegate = self;
    textField5.autocompleteTextColor = [UIColor darkGrayColor]; // set a custom color to autocomplete
    textField5.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    textField5.leftViewMode = UITextFieldViewModeAlways;
    textField6.delegate = self;
    
}

- (void)viewDidUnload
{
    [self setTextField1:nil];
    [self setTextField2:nil];
    [self setTextField3:nil];
    [self setTextField4:nil];
    [self setTextField5:nil];
    [self setTextField6:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [textField1 release];
    [textField2 release];
    [textField3 release];
    [textField4 release];
    [textField5 release];
    [textField6 release];
    [super dealloc];
}
@end
