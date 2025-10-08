//
//----------------------------------------------
// Original project: FM-3
// by  Stewart Lynch on 2025-09-05
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2025 CreaTECH Solutions. All rights reserved.


import SwiftUI
import FoundationModels


struct Topic {
    var title: String
    var catchPhrase: String
}

struct TopicTitles: View {
    @Environment(NavManager.self) var navManager
    @Environment(FoundationManager.self) var manager
    @Environment(\.scenePhase) private var scenePhase
    @State private var topic: String = ""
    @State private var topics: [Topic] = []
    @State private var number: Int = 10
    let session = LanguageModelSession()
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 8) {
                    TextField("Enter topic description", text: $topic, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    if !topic.isEmpty || !topics.isEmpty {
                        Button {
                            withAnimation {
                                topic = ""
                                topics.removeAll()
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                                .imageScale(.large)
                        }
                        .buttonStyle(.plain)
                    }
                }
                Stepper(value: $number, in: 1...100) {
                    Text("Number of suggestions: \(number)")
                }
                if manager.isModelAvailable {
                    Button("Generate Titles") {
                        
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(session.isResponding || topic.isEmpty)
                    List {


                    }
                    .listStyle(.plain)
                    .scrollBounceBehavior(.basedOnSize)
                    .overlay {
                        if session.isResponding {
                            VStack {
                                ProgressView()
                            }
                        }
                    }
                } else {
                    IntelligenceUnavailableView()
                }
            }
            .navigationTitle(navManager.selectedTab.rawValue)
            .padding()
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    manager.checkIsAvailable()
                }
            }
            .onChange(of: topic) { _, newValue in
                if newValue.isEmpty {
                    topics.removeAll()
                }
            }
        }
    }
    
    
}

#Preview {
    @Previewable @State var navManager = NavManager()
    TopicTitles()
        .environment(navManager)
        .environment(FoundationManager())
        .onAppear {
            navManager.selectedTab = MyTabs.guided2
        }
}

