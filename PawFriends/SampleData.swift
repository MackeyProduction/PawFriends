//
//  SampleData.swift
//  PawFriends
//
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            Advertisement.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func insertSampleData() {
        for advertisement in Advertisement.sampleData {
            context.insert(advertisement)
        }
        
        do {
            try context.save()
        } catch {
            print("Sample data context failed to save.")
        }
    }
    
    var advertisement: Advertisement {
        Advertisement.sampleData[0]
    }
    
}

