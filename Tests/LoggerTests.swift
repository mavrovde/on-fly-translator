import XCTest
@testable import on_fly_translator

class LoggerTests: XCTestCase {
    
    func testSingleton() {
        let instance1 = Logger.shared
        let instance2 = Logger.shared
        XCTAssertTrue(instance1 === instance2)
    }
    
    func testLogFileCreation() {
        let logger = Logger.shared
        let testMessage = "Test Log Entry \(UUID().uuidString)"
        
        logger.log(testMessage)
        
        // Allow file I/O to complete
        Thread.sleep(forTimeInterval: 0.1)
        
        do {
            let logContent = try String(contentsOf: logger.logURL, encoding: .utf8)
            XCTAssertTrue(logContent.contains(testMessage), "Log file should contain the logged message")
        } catch {
            XCTFail("Failed to read log file: \(error)")
        }
    }
}
