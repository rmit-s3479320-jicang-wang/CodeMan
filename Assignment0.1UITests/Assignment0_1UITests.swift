//
//  Assignment0_1UITests.swift
//  Assignment0.1UITests
//
//  Created by zb on 2018/1/24.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import XCTest

class Assignment0_1UITests: XCTestCase {
    
    var app: XCUIApplication?
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        self.app = XCUIApplication()
        self.app?.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMyApplication() {
        let tabbars = self.app?.tabBars
        // switch tabbaritem
        tabbars?.buttons["Featured"].tap()
        tabbars?.buttons["Contacts"].tap()
        tabbars?.buttons["Home"].tap()
        
        // add event
        let navigation = self.app?.navigationBars
        navigation?.buttons["+"].tap()
        self.app?.textFields["Title"].tap()
        self.app?.textFields["Title"].typeText("My title")
        self.app?.textFields["DateTime"].tap()
        
        let datePicker : XCUIElement = (self.app?.datePickers.element)!
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "10")
        datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "40")
        
        self.app?.buttons["Done"].tap()
        self.app?.textFields["Describe"].tap()
        self.app?.textFields["Describe"].typeText("My describtion")
        self.app?.searchFields["Address"].tap()
        self.app?.searchFields["Address"].typeText("Add")
        self.app?.keyboards.buttons["Search"].tap()
        
        sleep(3)
        navigation?.buttons["Add"].tap()
        
        sleep(1)
        // goto event info page
        var cells = self.app?.tables.element.cells
        assert(((cells?.count)! > 0), "add event failed!")
        cells?.element(boundBy: 0).tap()
        
        sleep(1)
        // goto event edit page
        navigation?.buttons["Edit"].tap()
        
        self.app?.textFields["My title"].tap()
        self.app?.textFields["My title"].typeText(" update")
        navigation?.buttons["Save"].tap()
        
        sleep(1)
        
        navigation?.buttons["Event"].tap()
        tabbars?.buttons["Featured"].tap()
        self.app?.buttons["Delete All Event"].tap()
        
        sleep(1)
        self.app?.alerts.buttons["Yes"].tap()
        tabbars?.buttons["Home"].tap()
        sleep(1)
        
        cells = self.app?.tables.element.cells
        assert(((cells?.count)! == 0), "delete all event failed!")
        
        self.app?.segmentedControls.element(boundBy: 0).buttons["Past"].tap()
        
        cells = self.app?.tables.element.cells
        assert(((cells?.count)! == 0), "delete all event failed!")
    }
    
}
