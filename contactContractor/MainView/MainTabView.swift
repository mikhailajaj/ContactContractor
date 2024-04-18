//
//  MainTabView.swift
//  Contact
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import SwiftUI
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            UserProfileView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
            InboxView()
                .tabItem {
                    Label("Inbox", systemImage: "message")
                }
        }
    }
}
