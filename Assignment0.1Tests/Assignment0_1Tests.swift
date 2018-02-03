

import XCTest

class Assignment0_1Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testWeatherApi() {
        let expectation = self.expectation(description: "")
        let timeout = 15 as TimeInterval
        queryWeather(latitude: 39.92642,
                     longitude: 116.447591) { (response) in
                expectation.fulfill()
                assert(response != nil, "Weather api request fail!")
        }
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
}
