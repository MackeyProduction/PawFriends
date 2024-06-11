//
//  PawFriendsApp.swift
//  PawFriends
//
//  Created by Til Anheier on 29.05.24.
//

import Amplify
import Authenticator
import AWSCognitoAuthPlugin
import SwiftUI
import SwiftData

@main
struct PawFriendsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Advertisement.self,
            Favorite.self,
            Message.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure(with: .amplifyOutputs)
        } catch {
            print("Unable to configure Amplify \(error)")
        }
    }
}
