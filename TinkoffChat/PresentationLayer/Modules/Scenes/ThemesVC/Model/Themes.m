//
//  Themes.m
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 3/20/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"

@implementation Themes

-(id) initWithValue1:(UIColor *)theme1_ value2: (UIColor *)theme2_ value3: (UIColor *) theme3_ {
    if (self = [super init]) {
        self.theme1 = [theme1_ retain];
        self.theme2 = [theme2_ retain];
        self.theme3 = [theme3_ retain];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s %@ deallocated", __PRETTY_FUNCTION__, self);
    [self.theme1 release];
    self.theme1 = nil;
    [self.theme2 release];
    self.theme2 = nil;
    [self.theme3 release];
    self.theme3 = nil;
    [super dealloc];
}

@end
