//
//  PostProjectView.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//
import Amplify
import SwiftUI
import PhotosUI

struct PostProjectView: View {
    @EnvironmentObject var userState: UserState
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var description: String = ""
    @State var image: UIImage?
    @State var shouldShowImagePicker: Bool = false
    @State var photoPickerItems = [PhotosPickerItem]()
    @State var images = [UIImage]()
    @State var postButtonIsDisabled: Bool = false

    let projectId = UUID().uuidString
    
    var body: some View {
        ScrollView {
            VStack {
                Button(action: { shouldShowImagePicker = true }) {
                    SelectImageView()
                }
                
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
                
                TextField("Name", text: $name)
                    .padding()
                
                TextEditor(text: $description)
                    .frame(height: 100)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                PhotosPicker(selection: $photoPickerItems, matching: .images, photoLibrary: .shared()) {
                    Label("Pick Photo", systemImage: "photo.on.rectangle.angled")
                }
                .onChange(of: photoPickerItems) { newValues in
                    Task {
                        images = []
                        for value in newValues {
                            if let imageData = try? await value.loadTransferable(type: Data.self),
                               let image = UIImage(data: imageData) {
                                images.append(image)
                            }
                        }
                    }
                }
                
                Button("Post") {
                    Task { await postProject() }
                }
                .buttonStyle(.borderedProminent)
                .disabled(postButtonIsDisabled)
                .padding()
            }
            .padding()
        }
        .navigationTitle("New Project")
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePickerView(image: $image)
        }
    }
    
    @ViewBuilder
    func SelectImageView() -> some View {
        if let image = self.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .clipped()
        } else {
            Image(systemName: "photo.on.rectangle.angled")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
    }
    
    func postProject() async {
        var imageKeys: [String] = []

        // Upload images
        for (index, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { continue }
            let imageKey = "\(projectId)\(index).jpg"

            do {
                let key = try await Amplify.Storage.uploadData(key: imageKey, data: imageData).value
                imageKeys.append(key)
            } catch {
                print("Failed to upload image: \(error)")
                return
            }
        }

        // Convert String keys to ImageProject objects
        let imageProjects: [ImageProject?] = imageKeys.map { key in
            ImageProject(imageKey: key, projectId: projectId)
        }

        // Create and save the project
        let newProject = Project(
            id: projectId,
            name: name,
            imageKey: imageKeys.first ?? "",
            description: description,
            userId: userState.userId,
            imageKeys: imageProjects,
            createdAt: Temporal.DateTime.now()
        )

        do {
            _ = try await Amplify.DataStore.save(newProject)
            print("Saved product: \(newProject)")
            dismiss.callAsFunction()
        } catch {
            print("Failed to save project: \(error)")
        }
    }

    

}

