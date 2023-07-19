//
//  PracticeSwiftUIApp.swift
//  PracticeSwiftUI
//
//  Created by Ragul Lakshmanan on 13/07/23.
//

import SwiftUI

@main
struct PracticeSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CombineBasicsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
