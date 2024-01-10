//
//  Wizard.swift
//  Wizard
//
//  Created by gssp on 12/28/23.
//

import SwiftUI

@main

struct MacGPTApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 400, height:600)
        }
        .commands {
            } // for whatever reason leaving .commands in skips open dialog
//            .windowStyle(.hiddenTitleBar)
//            .windowToolbarStyle(.unified)
//            .windowResizability(.automatic)
        
    }
    
}

