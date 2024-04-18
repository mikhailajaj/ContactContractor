//
//  User+Extensions.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-04-11.
//

import Foundation
extension User: Hashable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id &&
        lhs.useramen == rhs.useramen
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(useramen)
    }
}
