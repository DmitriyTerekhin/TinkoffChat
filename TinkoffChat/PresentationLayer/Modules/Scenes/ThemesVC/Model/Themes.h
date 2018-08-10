//
//  Themes.h
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 19/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Themes : NSObject

@property (nonatomic,retain) UIColor *theme1;
@property (nonatomic,retain) UIColor *theme2;
@property (nonatomic,retain) UIColor *theme3;

-(id) initWithValue1: (UIColor *)theme1_ value2: (UIColor *)theme2_ value3: (UIColor *) theme3_;

@end
