//
//  ContentView.swift
//  Navigation-SwiftUI
//
//  Created by Thiha Ye Yint Aung on 12/2/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("experience") private var experience: Experience?
    
    private var navigationModel: NavigationModel = .shared
    private var dataModel: DataModel = .shared
    
    #if os(macOS)
    @Environment(\.appearsActive) private var appearsActive
    #endif
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        
        Group {
            switch experience {
            case .stack:
                StackContentView()
            case .twoColumn:
                TwoColumnContentView()
            case .threeColumn:
                ThreeColumnContentView()
            case nil:
                VStack {
                    Text("🧑🏼‍🍳 Bon appétit!")
                        .font(.largeTitle)
                    ExperienceButton()
                }
                .padding()
                .onAppear {
                    navigationModel.showExperiencePicker = true
                }
            }
        }
        .environment(navigationModel)
        .environment(dataModel)
        .sheet(isPresented: $navigationModel.showExperiencePicker) {
            ExperiencePicker(experience: $experience)
        }
        .task {
            try? navigationModel.load()
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .background {
                try? navigationModel.save()
            }
        }
        #if os(macOS)
        .onChange(of: appearsActive) { _, appearsActive in
            if !appearsActive {
                try? navigationModel.save()
            }
        }
        #endif
    }
}

#Preview {
    ContentView()
}
