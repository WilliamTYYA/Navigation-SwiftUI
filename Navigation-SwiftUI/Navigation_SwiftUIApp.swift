//
//  Navigation_SwiftUIApp.swift
//  Navigation-SwiftUI
//
//  Created by Thiha Ye Yint Aung on 12/2/25.
//

import SwiftUI

@main
struct Navigation_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
                #endif
        }
        #if os(macOS)
        .commands {
            SidebarCommands()
        }
        #endif
    }
}
