//
//  contactContractorApp.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import SwiftUI
import  Amplify
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSS3StoragePlugin
import AWSAPIPlugin

@main
struct contactContractorApp: App {
    var body: some Scene {
        WindowGroup {
            SessionView()
        }
    }
    init() {
        configureAmplify()
    }
    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            try Amplify.configure()
            print("Successfully configured Amplify")
            
        } catch {
            print("Failed to initialize Amplify", error)
        }
    }
}
