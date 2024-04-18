//
//  MessagesView.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-04-11.
//

import SwiftUI
import Amplify
import Combine

struct MessagesView: View {
    @EnvironmentObject var userState: UserState
    // 1
    @State var messages: [Message] = []
    // 2
    @State var messageBody: String = ""
    
    @State var tokens: Set<AnyCancellable> = []
    // 3
    let chatRoom: ChatRoom
    let otherUser: User
    let projectId: String?
    
    init(chatRoom: ChatRoom, otherUser: User, projectId: String? = nil) {
        self.chatRoom = chatRoom
        self.otherUser = otherUser
        self.projectId = projectId ?? chatRoom.lastMessage?.projectId
    }
    
    var body: some View {
        VStack {
            // 4
            List(messages) { message in
                let sender = message.messageSenderId == userState.userId
                ? User(id: userState.userId, useramen: userState.username)
                : otherUser
                MessageListCell(message: message, sender: sender)
                    .flip()
            }
            .listStyle(.plain)
            .flip()
            
            // 5
            HStack {
                TextField("Message", text: $messageBody)
                Button("Send") {
                    Task { await sendMessage() }
                }
            }
            .padding()
        }
        .navigationTitle(otherUser.useramen)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: getMessages)
    }
    func getMessages() {
        // 1
        Amplify.Publisher.create(
            Amplify.DataStore.observeQuery(
                for: Message.self,
                where: Message.keys.chatroomID == chatRoom.id
            )
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
            // 2
            receiveValue: {
                self.messages = $0.sorted(by: { $0.dateTime > $1.dateTime })
            }
        )
        .store(in: &tokens)
    }
    func sendMessage() async {
        do {
            // 1
            let message = Message(
                body: messageBody,
                dateTime: .now(),
                sender: User(
                    id: userState.userId,
                    useramen: userState.username
                ),
                chatroomID: chatRoom.id,
                messageSenderId: userState.userId
            )
            try await Amplify.DataStore.save(message)
            
            // 2
            let lastMessage = LastMessage(
                body: messageBody,
                datetime: .now(),
                projectId:  projectId ?? ""
            )
            var updatedChatRoom = chatRoom
            updatedChatRoom.lastMessage = lastMessage
            try await Amplify.DataStore.save(updatedChatRoom)
            
            // 3
            messageBody.removeAll()
        } catch {
            print(error)
        }
    }
}
extension View {
    // 6
    func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
