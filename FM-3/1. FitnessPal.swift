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
    @State private var exercises: [Exercise] = []
    let session = LanguageModelSession(instructions: Instructions {
        "You are an experienced trainer."
        "Your specialty is dealing with existing injuries."
    })
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
                        guard manager.isModelAvailable else { return }
                        exercises.removeAll()
                        let prompt = Prompt {
                            "Recommend some exercises for a total length of \(totalLength) minutes."
                            "Your clients are in the age group \(ageGroup.rawValue)."
                            "The fitness level should be \(fitnessLevel.rawValue)."
                            "If the exercise requires holding position, make sure to indicate how long to hold each position."
                        }
                        Task {
                            exercises = try await session.respond(to: prompt, generating: [Exercise].self).content
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(session.isResponding)
                    List {
                        ForEach(exercises) { exercise in
                            VStack(alignment: .leading) {
                                Text(exercise.name).font(.title3.bold())
                                Text(exercise.instructions)
                                Text(exercise.benefits).foregroundStyle(.secondary)
                                Text("\(exercise.repetitions) repetitions")
                                Text("\(exercise.ageGroup.label) - \(exercise.fitness.rawValue)")
                            }
                        }
                    }
                    .listStyle(.plain)
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

@Generable
enum FitnessLevel: String, CaseIterable, Identifiable {
    case beginner, intermediate, advanced
    var id: Self { self }
}

@Generable
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

@Generable
struct Exercise: Identifiable {
    var id = UUID()
    
    @Guide(description: "The name of the exercise")
    let name: String
    
    @Guide(description: "A short description on how to perform the exercise")
    let instructions: String
    
    @Guide(description: "The benefits of performing the exercise")
    let benefits: String
    
    @Guide(description: "The exercise should be specific to this fitness level")
    let fitness: FitnessLevel
    
    @Guide(description: "The exerise should be appropriate for this age group")
    let ageGroup: AgeGoup
    
    @Guide(description: "The number of repetitions", .range(1...10))
    let repetitions: Int
}
