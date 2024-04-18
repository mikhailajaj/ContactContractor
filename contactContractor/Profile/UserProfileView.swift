//
//  UserProfileView.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import SwiftUI
import Amplify
import Combine

struct UserProfileView: View {
    // 1
    @EnvironmentObject var userState: UserState
    @State var isImagePickerVisible: Bool = false
    @State var  newAvatarImage: UIImage?
    @State var projects: [Project] = []
    @State var tokens: Set<AnyCancellable> = []
    
    
    var avatarState: AvatarState {
        newAvatarImage.flatMap({ AvatarState.local(image: $0) })
        ?? .remote(avatarKey: userState.userAvatarKey)
    }
    // 2
    let columns = Array(repeating: GridItem(.flexible(minimum: 150)), count: 2)
    
    var body: some View {
        // 1
        NavigationStack {
            // 2
            VStack {
                Button(action:  { isImagePickerVisible = true }) {
                    // 1
                    AvatarView(
                            state: avatarState,
                            fromMemoryCache: true
                        )
                    .frame(width: 75, height: 75)
                    .onChange(of: avatarState) { _ in
                        Task {
                            await uploadNewAvatar()
                        }
                    }
                }
                // 2
                Text(userState.username)
                    .font(.headline)
                // 3
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(projects) { project in
                            ProjectGridCell(Project: project)
                        }
                    }
                }.padding()
            }
            .navigationTitle("My Account")
            .sheet(isPresented: $isImagePickerVisible) {
                ImagePickerView(image: $newAvatarImage)
            }
            // 3
            .toolbar {
                ToolbarItem {
                    Button(
                        action: {Task {
                            await signOut()
                        }},
                        label: { Image(systemName: "rectangle.portrait.and.arrow.right") }
                    )
                }
            }
        }
        .onAppear(perform: observeCurrentUsersProjects)
    }
    func signOut() async {
        do {
            // 1
            _ = await Amplify.Auth.signOut()
            print("Signed out")
            // 2
            _ = try await Amplify.DataStore.clear()
        } catch {
            print(error)
        }
    }
    func uploadNewAvatar() async {
        // 1
        guard let avatarData = newAvatarImage?.jpegData(compressionQuality: 1) else { return }
        do {
            // 2
            let avatarKey = try await Amplify.Storage.uploadData(
                key: userState.userAvatarKey,
                data: avatarData
            ).value
            print("Finished uploading:", avatarKey)
        } catch {
            print(error)
        }
    }
    func observeCurrentUsersProjects() {
        // 1
        Amplify.Publisher.create(
            // 2
            Amplify.DataStore.observeQuery(
                for: Project.self,
                where: Project.keys.userId == userState.userId
            )
        )
        // 3
        .map(\.items)
        // 4
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { projects in
                print("project count:", projects.count)
                // 5
                self.projects = projects.sorted {
                    guard
                        let date1 = $0.createdAt,
                        let date2 = $1.createdAt
                    else { return false }
                    return date1 > date2
                }
            }
        )
        .store(in: &tokens)
    }
}
