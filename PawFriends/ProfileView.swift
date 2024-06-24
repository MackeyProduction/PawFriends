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
            ScrollView {
                VStack(spacing: 5) {
                   
                    ZStack {
                        HStack {
                            Text("Mein Profil")
                                .font(.title)
                                .fontWeight(.medium)
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: shareItem) {
                                Label("", systemImage: "square.and.arrow.up")
                            }
                            .padding(.bottom, 5)
                            .font(.title2)
                            Button(action: {}) {
                                Label("", systemImage: "gearshape.fill")
                            }
                            .font(.title2)
                        }
                    }.foregroundStyle(Color(textColor!))
                    
                    Divider()
                        .overlay(Color(textColor!))
                    
                    HStack {
                        Image(systemName: "person.crop.square.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.trailing, 2)
                            .foregroundColor(Color(firstColor!))
                        
                        VStack(alignment: .leading) {
                            Text("Anna")
                                .font(.largeTitle)
                            HStack {
                                Image(systemName: "bookmark")
                                Text("Aktiv seit: 12.03.23")
                                    .foregroundStyle(Color(textColor!))
                                    .padding(.leading, -5)
                            }
                        }
                        Spacer()
                    }.padding(.top)
                    
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text("2 Follower")
                        Spacer()
                    }
                    .padding([.top, .bottom], 5)
                    
                    HStack {
                        Image(systemName: "number.square")
                            .font(.headline)
                        TagCloudView(tags: ["Nicht-Raucher","sportlich","Katzen-Kenner"])
                    }
                    .padding([.top, .bottom], 5)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Beschreibung")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                    }
                    
                    HStack {
                        Text("Die Beschreibung ist eine Aufsatzart. Sie informiert sachlich über ein Objekt, dass betrachtet wird und beschrieben werden soll.\n\nDie verwendete Sprache sollte an die Zielgruppe angepasst sein.\n\nZiel einer Beschreibung ist es einen gegebenen Gegenstand oder Situation dem Leser blalba genauestens zu vermitteln.")
                        Spacer()
                    }
                    
                }
                
                Divider()
                    .overlay(Color(textColor!))
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Tiere")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "plus.square")
                            .font(.title2)
                    }.padding(.bottom, 5)
                    
                    let pets: [String] = ["Momo","Momo Klon"]
                    ForEach(pets, id: \.self) { pet in
                        ZStack {
                            HStack {
                                Image(systemName: "pawprint.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(Color(greenColorReverse!))
                                Text(pet)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            HStack {
                                Divider()
                                    .overlay(Color(textColor!))
                            }
                            HStack {
                                Text("Katze")
                                    .padding(.leading, 60)
                            }
                            HStack {
                                Spacer()
                                Image(systemName: "square.and.pencil")
                                    .font(.title3)
                                    .foregroundStyle(Color(greenColorReverse!))
                            }
                        }.padding(.top, 2)
                    }
                 
                }.padding(.top, 5).padding(.bottom, 5)
                
                Divider()
                    .overlay(Color(textColor!))
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Anzeigen")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "plus.square")
                            .font(.title2)
                    }.padding(.bottom, 5)
                    
                    let pets: [String] = ["Katzen-Sitter für Kater gesucht","Noch ein Anzeigen Titel"]
                    ForEach(pets, id: \.self) { pet in
                        VStack {
                            HStack {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 70))
                                    .foregroundStyle(Color(greenColorReverse!))
                                    .padding(-8)
                                VStack {
                                    HStack {
                                        Text(pet)
                                            .fontWeight(.medium)
                                        Spacer()
                                        
                                    }
                                    HStack {
                                        Image(systemName: "calendar")
                                            .font(.callout)
                                            .frame(width: 10)
                                            .padding(.leading, 5)
                                        Text("18.04.24")
                                            .padding(.trailing, 50)
                                        Spacer()
                                    }.foregroundStyle(Color(textColor!))
                                }
                                Spacer()
                                Image(systemName: "square.and.pencil")
                                    .font(.title3)
                                    .foregroundStyle(Color(greenColorReverse!))
                            }.padding(.top, 8)
                            Divider()
                        }
                    }
                    
                }.padding(.top, 5).padding(.bottom, 5)
                
                Spacer()
            }
            .padding(.leading)
            .padding(.trailing)
            .background(Color(mainColor!))
        } detail: {
            Text("Select an item")
                .navigationTitle("Profil")
        }
    }
    
    private func shareItem(){
        
    }
    
}

#Preview {
    ProfileView()
}
