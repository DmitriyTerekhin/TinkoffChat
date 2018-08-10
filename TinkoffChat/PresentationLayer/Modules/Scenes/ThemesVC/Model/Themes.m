//
//  Themes.m
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 3/20/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"

@interface Themes ()

@property (nonatomic, retain) UIColor *_theme1;
@property (nonatomic, retain) UIColor *_theme2;
@property (nonatomic, retain) UIColor *_theme3;

@end

@implementation Themes

-(id) initWithValue1:(UIColor *)theme1_ value2: (UIColor *)theme2_ value3: (UIColor *) theme3_ {
    if (self = [super init]) {
        self.theme1 = theme1_;
        self.theme2 = theme2_;
        self.theme3 = theme3_;
    }
    return self;
}

//theme1
- (void) setTheme1: (UIColor *)theme1 {
    if (theme1 != self._theme1) {
        [self._theme1 release];
        self._theme1 = [theme1 retain];
    }
}

-(UIColor *)theme1 {
    return self._theme1;
}

//theme2
- (void) setTheme2: (UIColor *)theme2 {
    if (theme2 != self._theme2) {
        [self._theme2 release];
        self._theme2 = [theme2 retain];
    }
}

-(UIColor *)theme2 {
    return self._theme2;
}

//theme3
- (void) setTheme3: (UIColor *)theme3 {
    if (theme3 != self._theme3) {
        [self._theme3 release];
        self._theme3 = [theme3 retain];
    }
}

-(UIColor *)theme3 {
    return self._theme3;
}

@end
