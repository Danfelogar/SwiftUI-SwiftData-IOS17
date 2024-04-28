//
//  SwiftUI_SwiftData_IOS17App.swift
//  SwiftUI-SwiftData-IOS17
//
//  Created by Daniel Felipe on 25/02/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftUI_SwiftData_IOS17App: App {
//    more complex and full personalized
//    let contianer: ModelContainer = {
//        let schema = Schema([Expense.self])
//        let contaienr  = try! ModelContainer(for: schema, configurations: [])
//        return container
//    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //.modelContainer(container)
        .modelContainer(for: [Expense.self])
    }
}
