

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
                XCTAssert(response != nil, "Weather api request fail!")
        }
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testWeatherDesc() {
        let expectation = self.expectation(description: "")
        let timeout = 15 as TimeInterval
        queryWeather(latitude: 39.92642,
                     longitude: 116.447591) { (response) in
                        expectation.fulfill()
                        XCTAssert(response != nil, "Weather api request fail!")
                        let arr = response?.object(forKey: "weather") as! NSArray
                        XCTAssert(arr.count > 0, "Weather data is null!")
                        let weather = arr.firstObject as! NSDictionary
                        let desc = weather.object(forKey: "description") as! NSString
                        XCTAssert(desc.length > 0, "Weather description is null!")
        }
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testEventObjectDateToString() {
        let eventObj = EventObject()
        XCTAssert(eventObj.dateToString() == "", "EventObject dateToString fail!")
    }
    
    func testWeatherTemp() {
        let expectation = self.expectation(description: "")
        let timeout = 15 as TimeInterval
        queryWeather(latitude: 39.92642,
                     longitude: 116.447591) { (response) in
                        expectation.fulfill()
                        XCTAssert(response != nil, "Weather api request fail!")
                        let arr = response?.object(forKey: "weather") as! NSArray
                        XCTAssert(arr.count > 0, "Weather data is null!")
                        let main = response?.object(forKey: "main") as! NSDictionary
                        XCTAssert(main.object(forKey: "temp") != nil, "Get temp fail!")
        }
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
}
