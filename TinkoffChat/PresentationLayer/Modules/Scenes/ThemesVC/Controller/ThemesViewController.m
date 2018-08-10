//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 17/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

#import "ThemesViewController.h"
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"
#import <UIKit/UIKit.h>

@interface ThemesViewController ()
@end

@implementation ThemesViewController

- (void)dealloc
{
    [_model release]; _model = nil;
    [_delegate release]; _delegate = nil;
    [_themeService release]; _themeService = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}
    
- (void)setupNavigationBar {
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Закрыть"
                                    style: UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(closeViewController:)];
    self.navigationItem.rightBarButtonItem = closeButton;
    [closeButton release];
}

- (IBAction)themeWasChoosen:(UIButton*)sender {
    
    UIColor *newColor;
    
    switch (sender.tag) {
        case 1:
        newColor = _model.theme1;
        break;
        case 2:
        newColor = _model.theme2;
        break;
        case 3:
        newColor = _model.theme3;
        break;
        default: newColor = UIColor.redColor; break;
    }
    [self view].backgroundColor = newColor;
    if ([self.delegate respondsToSelector: @selector(themesViewController:didSelectTheme:)]) {
        [self.delegate themesViewController: self didSelectTheme: newColor];
    }
}

    - (IBAction)closeViewController:(id) sender {
        [self dismissViewControllerAnimated: YES completion: nil];
    }

@end
