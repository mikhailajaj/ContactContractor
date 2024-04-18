//
//  UserState.swift
//  Contact
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import Foundation
class UserState: ObservableObject {
    var userId: String = ""
    var username: String = ""
    var userAvatarKey: String {
        userId + ".jpg"
    }
}

