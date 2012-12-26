<img src="https://raw.github.com/hoteltonight/HTDelegateProxy/master/ht-logo-black.png" alt="HotelTonight" title="HotelTonight" style="display:block; margin: 10px auto 30px auto;">

HTDelegateProxy
===============

# Overview

HTDelegateProxy is an NSProxy subclass that allows you to assign multiple delegates to a single source. <br/>
Check out the associated blog post at http://engineering.hoteltonight.com/handling-multiple-delegates-in-ios

HTDelegateProxy operates on two simple rules:

1. Messages with a void return type are sent to all target delegates that reponds to the selector
2. Messages with non-void return types are sent only to the <i>first</i> delegate in the list that responds to the selector.

This pattern seems to be effective in identifying which messages are informative (hey, something happened) and which messages are more complex interactions (how should I do this?).

# Installation

### Cocoapods users:
Add the following line to your Podfile: <br/>
pod 'HTDelegateProxy', '~> 0.0.2'

### Everyone else:
Add the HTDelegateProxy.m/h files to your project.

# Usage

Delegates are not retained, so you have to maintain a strong reference to your HTDelegateProxy instance. <br/>
### In your interface: <br/>
    
    #import "HTDelegateProxy.h"
    ...
    @property (nonatomic, strong) UIScrollView *scrollView;
    @property (nonatomic, strong) HTDelegateProxy *delegateProxy;
    ...

### In your class:

    ...
    self.scrollView = [[UIScrollView alloc] init];
    self.delegateProxy = [[HTDelegateProxy alloc] init];
    self.delegateProxy.delegates = @[firstDelegate, secondDelegate];
    self.scrollView.delegate = (id)self.delegateProxy;
    ...


    