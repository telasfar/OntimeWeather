//

//

import XCTest
@testable import OnTime_Weather_App

class OnTime_Weather_AppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGettingJSON() {
        let ex = expectation(description: "Expecting a JSON data not nil")
    
        DataService.instance.getWeatherByCity(city: "cairo", country: "Egypt"){ (success, weather) in
            XCTAssert(success)
            XCTAssertNotNil(weather)
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
          if let error = error {
            XCTFail("error: \(error)")
          }
        }
    }

    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
