//
//  PawFriendsApp.swift
//  PawFriends
//
//  Created by Til Anheier on 29.05.24.
//

import Amplify
import Authenticator
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import SwiftUI

@main
struct PawFriendsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(userProfileViewModel: UserProfileViewModel(), advertisementViewModel: AdvertisementViewModel())
        }
    }
    
    init() {
        let awsApiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: awsApiPlugin)
            try Amplify.configure(with: .amplifyOutputs)
            print("Initialized Amplify");
        } catch {
            print("Unable to configure Amplify \(error)")
        }
    }
}
