//
//  HomeView.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import SwiftUI
import Amplify
import Combine

struct HomeView: View {
    // 1
    @StateObject var navigationCoordinator: HomeNavigationCoordinator = .init()
    // 2
    @State var projects: [Project] = []
    
    @State var tokens: Set<AnyCancellable> = []
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 150)), count: 2)
    
    var body: some View {
        // 3
        NavigationStack(path: $navigationCoordinator.routes) {
            // 4
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(projects) { project in
                        // 5
                        NavigationLink(value: HomeRoute.projectDetails(project)) {
                            ProjectGridCell(Project: project)
                        }
                    }
                }.padding()
            }
            .navigationTitle("Home")
            // 6
            .toolbar {
                ToolbarItem {
                    Button(
                        action: { navigationCoordinator.routes.append(.postNewProject) },
                        label: { Image(systemName: "plus") }
                    )
                }
            }
            // 7
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .postNewProject:
                    PostProjectView()
                case .projectDetails(let project):
                    ProjectDetailsView(project: project)
                        .environmentObject(navigationCoordinator)
                case .chat(chatRoom: let chatRoom, otherUser: let user, productId: let id):
                    MessagesView(chatRoom: chatRoom, otherUser: user, projectId: id)
                }
            }
        }
        .onAppear(perform: observeProjects)
        
    }
    func observeProjects() {
        // 1
        Amplify.Publisher.create(
            Amplify.DataStore.observeQuery(for: Project.self)
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        // 2
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { projects in
                self.projects = projects.sorted {
                    guard
                        let date1 = $0.createdAt,
                        let date2 = $1.createdAt
                    else { return false }
                    return date1 > date2
                }
                print("Received projects: \(projects.count)")
            }
        )
        .store(in: &tokens)
       
    }
}
