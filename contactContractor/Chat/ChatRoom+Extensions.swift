//
//  ChatRoom+Extensions.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-04-11.
//

// 1
extension ChatRoom: Identifiable {}
// 2
extension ChatRoom: Hashable {
    public static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        lhs.id == rhs.id &&
        lhs.memberIds == rhs.memberIds
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(memberIds)
    }
}
// 3
extension ChatRoom {
    func otherMemberId(currentUser id: String) -> String {
        let otherMemberId = self.memberIds?.first {
            $0 != id
        }
        return otherMemberId ?? ""
    }
}
