import XCTest
@testable import on_fly_translator

class GoogleGeminiServiceTests: XCTestCase {
    
    var service: GoogleGeminiService!
    
    override func setUp() {
        super.setUp()
        service = GoogleGeminiService()
    }
    
    func testRequestCreation() {
        let request = service.makeRequest(text: "Hello", from: "English", to: "German", apiKey: "TEST_KEY")
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertEqual(request?.url?.absoluteString, "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=TEST_KEY")
        
        // Verify Body
        if let body = request?.httpBody,
           let json = try? JSONSerialization.jsonObject(with: body, options: []) as? [String: Any],
           let contents = json["contents"] as? [[String: Any]],
           let parts = contents.first?["parts"] as? [[String: Any]],
           let text = parts.first?["text"] as? String {
            
            XCTAssertTrue(text.contains("Translate the following text from English to German"))
            XCTAssertTrue(text.contains("Hello"))
        } else {
            XCTFail("Failed to parse request body")
        }
    }
    
    func testMissingAPIKeyError() {
        // Clear key
        UserDefaults.standard.removeObject(forKey: "GeminiAPIKey")
        
        let expectation = self.expectation(description: "Completion handler called")
        
        service.translate(text: "Hi", from: "En", to: "De") { result in
            switch result {
            case .success:
                XCTFail("Should fail without API Key")
            case .failure(let error):
                if let error = error as? TranslationError {
                    switch error {
                    case .noAPIKey:
                        XCTAssertTrue(true) // Success
                    default:
                        XCTFail("Wrong error type: \(error)")
                    }
                } else {
                    XCTFail("Expected TranslationError, got \(error)")
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
