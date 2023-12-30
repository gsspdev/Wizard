// AppDelegate.swift
import AppKit

//@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    
class PersistentWindow: NSWindow {
    override func becomeKey() {
        super.becomeKey()
        self.level = .floating // Keeps the window on top until closed.
    }
}
    var viewController: ViewController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the window and set the content view.
        window = PersistentWindow(
            contentRect: NSMakeRect(0, 0, 480, 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        
        window.title = "ChatGPT Wrapper"
        window.center()
        window.makeKeyAndOrderFront(viewController)

        // Set the view controller as the window's content
        viewController = ViewController()
        window.contentViewController = viewController
    }
}
