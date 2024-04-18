//
//  ProjectDetailsView.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import AmplifyImage
import SwiftUI
import Amplify

struct ProjectDetailsView: View {
    @EnvironmentObject var navigationCoordinator: HomeNavigationCoordinator
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userState: UserState
    // 1
    
    let project: Project
    @State var images: [UIImage] = []
    
    var body: some View {
        ScrollView {
            // 2
            VStack {
                AmplifyImage(key: project.imageKey)
                    .scaleToFillWidth()
                if !images.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(images, id: \.self) { img in
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                                    .onTapGesture {
                                        // Handle tap gesture if needed
                                    }
                            }
                        }
                    }
                }
                project.description.flatMap(Text.init)
                
                // 3
                if userState.userId != project.userId {
                    Button("Chat") {
                        Task { await getOrCreateChatRoom() }
                    }
                } else {
                    Button("Delete project") {
                        Task { await deleteProject() }
                    }
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                }
                    
            }
            .navigationTitle(project.name)
        }.onAppear {
            Task {
                await loadImages()
            }
        }
    }
    func deleteProject() async {
        do {
            // 1
            try await Amplify.DataStore.delete(project)
            print("Deleted project \(project.id)")
            
            // 2
            let projectImageKey = project.id + ".jpg"
            try await Amplify.Storage.remove(key: projectImageKey)
            print("Deleted file: \(projectImageKey)")
            
            dismiss.callAsFunction()
        } catch {
            print(error)
        }
    }
    func loadImages() async {
        guard let imageKeys = project.imageKeys, !imageKeys.isEmpty else {
            print("Project has no additional images.")
            return
        }
        
        // Temporary array to hold loaded images
        //var loadedImages: [UIImage] = []
        
        for imageProject in imageKeys {
            guard let key = imageProject!.imageKey else {
                print("Image key is nil, skipping")
                continue // Skip this iteration if there's no key
            }
            
            do {
                let imageData = try await Amplify.Storage.downloadData(key: key).value
                if let image = UIImage(data: imageData) {
                    // Append to the temporary array instead of the state variable
                    images.append(image)
                }
            } catch {
                print("Error downloading image: \(error)")
            }
        }
            /*
        // Update the state variable once after all images have been loaded
        DispatchQueue.main.async {
            self.images = loadedImages
        }
             */
    }

    func getOrCreateChatRoom() async {
        do {
            // 1
            let chatRooms = try await Amplify.DataStore.query(
                ChatRoom.self,
                where: ChatRoom.keys.memberIds.contains(project.userId)
                    && ChatRoom.keys.memberIds.contains(userState.userId)
            )
            
            // 2
            let chatRoom: ChatRoom
            if let existingChatRoom = chatRooms.first {
                chatRoom = existingChatRoom
            } else {
                let newChatRoom = ChatRoom(memberIds: [project.userId, userState.userId])
                let savedChatRoom = try await Amplify.DataStore.save(newChatRoom)
                chatRoom = savedChatRoom
            }
            
            // 3
            let otherUser = try await Amplify.DataStore.query(
                User.self,
                byId: chatRoom.otherMemberId(currentUser: userState.userId)
            )
            
            // 4
            navigationCoordinator.routes.append(
                .chat(
                    chatRoom: chatRoom,
                    otherUser: otherUser!,
                    productId: project.id
                )
            )
        } catch {
            print(error)
        }
    }
   
}
