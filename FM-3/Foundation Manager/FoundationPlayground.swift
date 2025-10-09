//
//----------------------------------------------
// Original project: FM - 2
// by  Stewart Lynch on 2025-08-31
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

//

import Foundation
import Playgrounds
import FoundationModels

#Playground("Basic") {
    let session = LanguageModelSession()
    let prompt = Prompt("What are the colors of the rainbow")
    try await session.respond(to: prompt)
}

#Playground("Prompt Builder") {
    let session = LanguageModelSession()
    let prompt = Prompt {
        "I want an exercise routine"
        "I want it to focus on the lower back"
        "I want it to be for 20 minutes."
    }
    try await session.respond(to: prompt)
}

#Playground("Guided Generation") {
    let session = LanguageModelSession()
    let prompt = Prompt {
        "Recommend some exercises for a total length of 10 minutes."
        "Your clients are in the age group over 65 years old."
        "The fitness level should be intermediate."
        "If the exercise requires holding position, make sure to indicate how long to hold each position."
    }
    
    try await session.respond(to: prompt, generating: [Exercise].self)
}
