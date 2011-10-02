#DOAutocompleteTextField

DOAutocompleteTextField is a subclass of UITextField that provide the user with
autocompleted text, similar to the URL bar on major browsers and Google Suggest.

![DOAutocompleteTextField Screenshot](https://github.com/doat/DOAutocompleteTextField/raw/master/screenshot.gif)

#Usage

Add DOAutocompleteTextField to your project, create an instance of it
as you would create a UITextField and set the delegate.

    DOAutocompleteTextField *textField = [[DOAutocompleteTextField alloc] initWithFrame:CGRectMake(0,0,100,31)];
    textField.delegate = self;

In your DOAutocompleteTextFieldDelegate provide the completions according to you own logic
or similar to the demo.
	
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

DOAutocompleteTextField draws the completion text immediatlly after user input.

#Known Issues

* Completion position is still a bit off.
* No way of detecting taps on autocomplete label.


##Copyright
Copyright 2011 DoAT. All rights reserved. See LICENSE for more details.
