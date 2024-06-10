//
//  ProfileView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    Text("Profil")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("Markus")
                            .font(.largeTitle)
                        
                        HStack {
                            Image(systemName: "bookmark")
                            Text("Aktiv seit: xx.xx.xxxx")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                HStack {
                    Image(systemName: "person.3.fill")
                    Text("2 Follower")
                    Spacer()
                }
                .padding([.top, .bottom], 5)
                
                HStack {
                    Image(systemName: "bookmark")
                    Text("Tags")
                    Spacer()
                }
                .padding([.top, .bottom], 5)
            }
            .padding(.all)
            .frame(maxWidth: .infinity)
            .background(.green)
            .foregroundStyle(.white)
            
            VStack {
                HStack {
                    Text("Beschreibung")
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Image(systemName: "pencil")
                }
                
                HStack {
                    Text("Lorem Ipsum")
                    Spacer()
                }
                
            }
            .padding(.all)
            
            VStack {
                HStack {
                    Text("Tiere")
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Image(systemName: "plus.square")
                }
                
                HStack {
                    Text("Lorem Ipsum")
                    Spacer()
                }
                
            }
            .padding(.all)
            
            VStack {
                HStack {
                    Text("Anzeigen")
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Image(systemName: "plus.square")
                }
                
                HStack {
                    Text("Lorem Ipsum")
                    Spacer()
                }
                
            }
            .padding(.all)
            
            Spacer()
        } detail: {
            Text("Select an item")
                .navigationTitle("Profil")
        }
    }
}

#Preview {
    ProfileView()
}
