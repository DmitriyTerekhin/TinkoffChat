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

@property (nonatomic, weak) id <ThemesViewControllerDelegate> delegate;
@property (retain) id <IThemeService> themeService;
@property (retain) Themes *model;

- (IBAction)themeWasChoosen:(UIButton*)sender;
@end
