//
//  HomeRoute.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import Foundation
enum HomeRoute: Hashable {
    case projectDetails(Project)
    case postNewProject
    case chat(chatRoom: ChatRoom, otherUser: User, productId: String)
}
class HomeNavigationCoordinator: ObservableObject {
    @Published var routes: [HomeRoute] = []
}
