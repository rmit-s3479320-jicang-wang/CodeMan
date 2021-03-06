
import XCTest
//the test based on the app have no event added before, and in the added page,
// when test the map search function, the keyboard must be oppened,it can be opened  by using(commond + shift + k)
// if not open the keyboard when test the map saerch function. the test will fail
//and the time can not at 11: 59 because it will influence the time add function
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
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "11")
        datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "59")
        
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
        navigation?.buttons["Delete All"].tap()
        
        sleep(1)
        self.app?.alerts.buttons["Yes"].tap()
        sleep(1)
        
        cells = self.app?.tables.element.cells
        assert(((cells?.count)! == 0), "delete all event failed!")
        
        self.app?.segmentedControls.element(boundBy: 0).buttons["Past"].tap()
        
        cells = self.app?.tables.element.cells
        assert(((cells?.count)! == 0), "delete all event failed!")
    }
    
}
