//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 17/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"
@protocol IThemeService;
@protocol ThemesViewControllerDelegate;

@interface ThemesViewController : UIViewController

@property (nonatomic, retain) id <ThemesViewControllerDelegate> delegate;
@property (nonatomic, strong) id <IThemeService> themeService;
@property (nonatomic, retain) Themes *model;

- (IBAction)themeWasChoosen:(UIButton*)sender;
@end
