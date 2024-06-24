//
//  MessageDetail.swift
//  PawFriends
//
//  Created by Til Anheier on 23.06.24.
//

import SwiftUI
import Amplify
import class Amplify.List

struct MessageDetail: View {
    @ObservedObject var vm: UserProfileViewModel
    @Binding var chats: [Chat]
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Nachrichtenliste
            ScrollView {
                VStack {
                    ForEach(chats, id: \.id) { chat in
                        VStack {
                            if chat.recipient != vm.userProfile?.author {
                                Spacer()
                                
                                HStack {
                                    Text(chat.message ?? "")
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    
                                    Image("TestImage2")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                }
                                
                                Text("\(chat.updatedAt?.iso8601FormattedString(format: TemporalFormat.short, timeZone: TimeZone.current) ?? "")")
                                    .font(.body)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                HStack {
                                    Image("TestImage1")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                    
                                    Text(chat.message ?? "")
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Text("\(chat.updatedAt?.iso8601FormattedString(format: TemporalFormat.short, timeZone: TimeZone.current) ?? "")")
                                    .font(.body)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 5)
                    }
                }
            }
            
            Spacer()
            
            // Eingabefeld für neue Nachrichten
            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                Button(action: {
                    sendMessage()
                }) {
                    Text("Send")
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.trailing)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("TestImage2")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text("Messages")
                            .font(.headline)
                    }
                }
            }
        }
    }
    
    private func sendMessage() {
        // Hier die Logik für das Senden der Nachricht hinzufügen
        print("New message: \(newMessage)")
        newMessage = ""
    }
}

#Preview {
    NavigationStack {
        if let chats = UserProfileViewModel.sampleData[0].chats {
            @State var chatsArray = Array(chats)
            @StateObject var userProfileViewModel = UserProfileViewModel()
            MessageDetail(vm: userProfileViewModel, chats: $chatsArray)
        }
    }
}
