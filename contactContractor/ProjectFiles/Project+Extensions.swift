//
//  Project+Extensions.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import Foundation


extension Project: Identifiable {}
extension Project: Hashable {
    // 1
    public static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.imageKeys == rhs.imageKeys
    }
    // 2
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(imageKeys)
    }
    
   
}
extension ImageProject : Equatable, Hashable{
    public static func == (lhs: ImageProject, rhs: ImageProject) -> Bool {
            lhs.imageKey == rhs.imageKey && lhs.projectId == rhs.projectId
        }
    // Hashable implementation
        public func hash(into hasher: inout Hasher) {
            hasher.combine(imageKey)
            hasher.combine(projectId)
        }
    
}
