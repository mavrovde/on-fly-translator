import Cocoa
#if canImport(TranslatorLib)
import TranslatorLib
#endif

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
