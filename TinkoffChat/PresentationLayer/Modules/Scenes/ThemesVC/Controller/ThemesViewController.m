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
#import "TinkoffChat-Swift.h"

@interface ThemesViewController ()
@end

@implementation ThemesViewController

@synthesize delegate;
@synthesize themeService;
@synthesize model;

- (void)dealloc
{
    printf("Theme dealloc");
    
    [themeService release];
    themeService = nil;
    
    [model release];
    model = nil;
    
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
    [closeButton autorelease];
}

- (IBAction)themeWasChoosen:(UIButton*)sender {

    UINavigationBar *bar = [self.navigationController navigationBar];
    bar.backgroundColor = [themeService getColorFrom: model with: sender.tag];
    
    if ([self.delegate respondsToSelector: @selector(themesViewController:didSelectTheme:)]) {
        [self.delegate themesViewController: self didSelectTheme: [themeService getColorFrom: model with: sender.tag]];
    }
}

    - (IBAction)closeViewController:(id) sender {
        [self dismissViewControllerAnimated: YES completion: nil];
    }

@end
