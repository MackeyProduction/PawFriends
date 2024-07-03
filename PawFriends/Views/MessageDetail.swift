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
    @State private var advertisement: Advertisement? = nil
    @State private var recipient: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            // Nachrichtenliste
            ScrollView {
                VStack {
                    ForEach(chats, id: \.id) { chat in
                        VStack {
                            if chat.recipient != vm.userProfile?.id {
                                Spacer()
                                
                                HStack {
                                    Text(chat.message ?? "")
                                        .padding()
                                        .background(Color(greenColorReverse!))
                                        .cornerRadius(10)
                                        .foregroundColor(Color(mainColor!))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    
                                    Image("TestImage2")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                }
                                
                                Text("\(dateToString(date: chat.updatedAt ?? Temporal.DateTime.now()))")
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
                                        .background(Color(greenColor!))
                                        .cornerRadius(10)
                                        .foregroundColor(Color(mainTextColor!))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Text("\(dateToString(date: chat.updatedAt ?? Temporal.DateTime.now()))")
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
                        .background(Color(greenColorReverse!))
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
        .background(Color(mainColor!))
        .onAppear {
            Task {
                self.advertisement = try await chats.first?.advertisement
                self.recipient = advertisement?.author
            }
        }
    }
    
    private func sendMessage() {
        Task {
            if let author = recipient, let up = vm.userProfile, let ad = advertisement {
                await vm.createChat(message: newMessage, recipient: author.uppercased(), userProfile: up, advertisement: ad)
            }
            newMessage = ""
        }
    }
    
    func dateToString(date: Temporal.DateTime) -> String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "de_DE")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let timeString = timeFormatter.string(from: date.foundationDate)
        let relativeDateString = relativeDateFormatter.string(from: date.foundationDate)
        let RelativeDateTimeString = relativeDateString+", "+timeString
        
        return RelativeDateTimeString
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
