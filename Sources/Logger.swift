import Foundation

public class Logger {
    public static let shared = Logger()
    let logURL: URL
    
    private init() {
        let home = FileManager.default.homeDirectoryForCurrentUser
        logURL = home.appendingPathComponent("translator.log")
    }
    
    public func log(_ message: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let logMessage = "[\(timestamp)] \(message)\n"
        
        if let data = logMessage.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logURL.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                try? data.write(to: logURL)
            }
        }
    }
}
