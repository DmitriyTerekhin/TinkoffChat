//
//  ThemeViewControllerTests.swift
//  TinkoffChatUnitTests
//
//  Created by Дмитрий Терехин on 5/29/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import XCTest
@testable import TinkoffChat

class ThemeViewControllerTests: XCTestCase {
    
     /// Тестируемый класс
    var themeViewController: ThemesViewController!
    var classMockForThemeViewComtrollerDelegate: ClassMockForThemeViewComtrollerDelegate!
    
    override func setUp() {
        super.setUp()
        themeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeIdentifier") as! ThemesViewController
        themeViewController.model = Themes(value1: UIColor.orange, value2: UIColor.purple, value3: UIColor.gray)
        _ = themeViewController.view
        classMockForThemeViewComtrollerDelegate = ClassMockForThemeViewComtrollerDelegate()
        themeViewController.delegate = classMockForThemeViewComtrollerDelegate
    }
    
    override func tearDown() {
        themeViewController = nil
        super.tearDown()
    }
    
    func testThat_themeModelNotEmpty() {
        XCTAssertNotNil(themeViewController.model)
        XCTAssertEqual(themeViewController.model.theme1, UIColor.orange)
        XCTAssertEqual(themeViewController.model.theme3, UIColor.gray)
    }
    
    func testThat_WhenPressOnFirstButtonCalledFunctionWithName_themeWasChoosen() {
        //given
        themeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeIdentifier") as! ThemesViewController
        themeViewController.model = Themes(value1: UIColor.orange, value2: UIColor.purple, value3: UIColor.gray)
        classMockForThemeViewComtrollerDelegate = ClassMockForThemeViewComtrollerDelegate()
        themeViewController.delegate = classMockForThemeViewComtrollerDelegate
        
        let button = UIButton()
        button.tag = 1
        
        //when
        themeViewController.themeWasChoosen(button)
        
        // then
        XCTAssertTrue(classMockForThemeViewComtrollerDelegate.wasDelegateCalled)
    }
    
    func testThat_WhenPressOnSecondButtonCalledFunctionWithName_themeWasChoosen() {
        //given
        themeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeIdentifier") as! ThemesViewController
        themeViewController.model = Themes(value1: UIColor.orange, value2: UIColor.purple, value3: UIColor.gray)
        classMockForThemeViewComtrollerDelegate = ClassMockForThemeViewComtrollerDelegate()
        themeViewController.delegate = classMockForThemeViewComtrollerDelegate
        
        let button = UIButton()
        button.tag = 2
        
        //when
        themeViewController.themeWasChoosen(button)
        
        // then
        XCTAssertTrue(classMockForThemeViewComtrollerDelegate.wasDelegateCalled)
    }
    
    func testThat_WhenPressOnThirdButtonCalledFunctionWithName_themeWasChoosen() {
        //given
        themeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeIdentifier") as! ThemesViewController
        themeViewController.model = Themes(value1: UIColor.orange, value2: UIColor.purple, value3: UIColor.gray)
        classMockForThemeViewComtrollerDelegate = ClassMockForThemeViewComtrollerDelegate()
        themeViewController.delegate = classMockForThemeViewComtrollerDelegate
        
        let button = UIButton()
        button.tag = 3
        
        //when
        themeViewController.themeWasChoosen(button)
        
        // then
        XCTAssertTrue(classMockForThemeViewComtrollerDelegate.wasDelegateCalled)
    }
    
}

class ClassMockForThemeViewComtrollerDelegate: UIViewController, ThemesViewControllerDelegate {
    var wasDelegateCalled = false
    
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        wasDelegateCalled = true
    }
}
