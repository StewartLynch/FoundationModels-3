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

@Generable
struct Topic {
    @Guide(description: "The topic title")
    var title: String
    
    @Guide(description: "A subtitle or catch phrase for the topic")
    var catchPhrase: String
}

struct TopicTitles: View {
    @Environment(NavManager.self) var navManager
    @Environment(FoundationManager.self) var manager
    @Environment(\.scenePhase) private var scenePhase
    @State private var topic: String = ""
    @State private var topics: [Topic].PartiallyGenerated = []
    @State private var number: Int = 10
    @State private var session = LanguageModelSession(instructions: "You are a creative marketing expert and your job is to generate creative titles and catch phrases for the topic specified.")
    @State private var errorString: String?
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
                        guard manager.isModelAvailable else { return }
                        topics.removeAll()
                        let prompt = "Create \(number) topics based on \(topic)"
                        let stream = session.streamResponse(to: prompt, generating: [Topic].self)
                        Task {
                            do {
                                for try await partialResponse in stream {
                                    withAnimation {
                                        topics = partialResponse.content
                                    }
                                }
                            } catch let error as LanguageModelSession.GenerationError {
                                switch error {
                                case .guardrailViolation(let context):
                                    errorString = "Guardrail Violation: \(context.debugDescription)"
                                case .decodingFailure(let context):
                                    errorString = "Decoding Failure: \(context.debugDescription)"
                                case .rateLimited(let context):
                                    errorString = "Rate Limit exceeded: \(context.debugDescription)"
                                default:
                                    errorString = "Other error: \(error.localizedDescription)"
                                }
                                if let failureReason = error.failureReason {
                                    errorString! += "\n\(failureReason)"
                                }
                                if let recoverySuggestion = error.recoverySuggestion {
                                    errorString! += "\n\(recoverySuggestion)"
                                }
                            
                            } catch {
                                errorString = error.localizedDescription
                            }
                        }
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(session.isResponding || topic.isEmpty)
                    List {
                        ForEach(topics) { topic in
                            if let title = topic.title, let catchPhrase = topic.catchPhrase {
                                VStack(alignment: .leading) {
                                    Text(title).font(.title3.bold())
                                    Text(catchPhrase).font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                        }

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
            .alert("Prompt Error", isPresented: .constant(errorString != nil)) {
                Button("OK") {
                    errorString = nil
                    topic = ""
                }
            } message: {
                if let errorString {
                    Text(errorString)
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

