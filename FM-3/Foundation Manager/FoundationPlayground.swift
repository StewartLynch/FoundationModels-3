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

