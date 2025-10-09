//
//----------------------------------------------
// Original project: FM-3
// by  Stewart Lynch on 2025-10-07
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

struct FitnessPal: View {
    @Environment(FoundationManager.self) var manager
    @Environment(NavManager.self) var navManager
    @State private var fitnessLevel:FitnessLevel = .intermediate
    @State private var ageGroup:AgeGoup = .senior
    @State private var totalLength: Double = 10
    @State private var responseContent = ""
    let session = LanguageModelSession()
    var body: some View {
        NavigationStack {
            VStack {
                LabeledContent("Fitness Level") {
                    Picker("Fitness Level", selection: $fitnessLevel) {
                        ForEach(FitnessLevel.allCases) { level in
                            Text(level.rawValue.capitalized)
                        }
                    }
                }
                LabeledContent("Age Group") {
                    Picker("Age Group", selection: $ageGroup) {
                        ForEach(AgeGoup.allCases) { group in
                            Text(group.label.capitalized)
                        }
                    }
                }
                Slider(value: $totalLength, in: 5...60) {
                    Text("Length")
                } ticks: {
                    SliderTickContentForEach(
                        stride(from: 5, through: 60, by: 5).map { $0 },
                        id: \.self
                    ) { value in
                        SliderTick(value)
                    }
                }
                Text("Length: \(totalLength, format: .number.precision(.fractionLength(0))) minutes")
                if manager.isModelAvailable {
                    Button("Get exercises") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(session.isResponding)
                    ScrollView {
                        Text(.init(responseContent))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                    }
                    .background(.quinary)
                    .clipShape(.rect(cornerRadius: 20))
                    .overlay {
                        if session.isResponding {
                            VStack {
                                Text("Getting Exercises")
                                ProgressView()
                            }
                        }
                    }
                } else {
                    IntelligenceUnavailableView()
                }
            }
            .padding()
            .navigationTitle(navManager.selectedTab.rawValue)
        }
    }
}

#Preview {
    FitnessPal()
        .environment(FoundationManager())
        .environment(NavManager())
}


enum FitnessLevel: String, CaseIterable, Identifiable {
    case beginner, intermediate, advanced
    var id: Self { self }
}

enum AgeGoup: String, CaseIterable, Identifiable {
    case teenager = "10 to 19 years old"
    case young = "between 20 and 40 years old"
    case middleAge = "between 42 and 65 years old"
    case senior = "over 65 years old"
    
    var label: String {
        switch self {
        case .teenager:
            "teenager"
        case .young:
            "young adult"
        case .middleAge:
            "middle age"
        case .senior:
            "senior"
        }
    }
    var id: Self { self }
}
