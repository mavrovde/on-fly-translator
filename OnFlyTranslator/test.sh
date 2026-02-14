#!/bin/bash
cd "$(dirname "$0")"

echo "Building Tests..."

# We need to compile the Sources (excluding main.swift) and the Tests.
# We create a temporary test main.

cat > Tests/LinuxMain.swift <<EOF
import XCTest
@testable import OnFlyTranslatorTests

// Manual registering might be needed depending on Swift version, 
// but let's try just running the bundle or creating a executable that imports XCTest.

// Actually, on macOS, the easiest way without SPM is to compile everything into an executable 
// and call XCTMain([testCase(GoogleGeminiServiceTests.allTests)]).
// But for that we need to add 'allTests' to the class.
EOF

# Simply compiling the test file + sources into a binary often works if we add a call to XCTMain
# checking GoogleGeminiServiceTests.swift again...

cat > Tests/RunTests.swift <<EOF
import XCTest

@main
struct TestRunner {
    static func main() {
        // Create the suite
        let suite = XCTestSuite(name: "All Tests")
        suite.addTest(GoogleGeminiServiceTests(selector: #selector(GoogleGeminiServiceTests.testRequestCreation)))
        suite.addTest(GoogleGeminiServiceTests(selector: #selector(GoogleGeminiServiceTests.testMissingAPIKeyError)))
        
        // Run
        suite.run()
    }
}
EOF

# Compile
swiftc \
    Sources/GoogleGeminiService.swift \
    Sources/Logger.swift \
    Tests/GoogleGeminiServiceTests.swift \
    Tests/RunTests.swift \
    -o Tests/OnFlyTranslatorTests

if [ $? -eq 0 ]; then
    echo "Running Tests..."
    ./Tests/OnFlyTranslatorTests
else
    echo "Compilation Failed"
    exit 1
fi
