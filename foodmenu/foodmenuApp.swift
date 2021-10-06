//
//  foodmenuApp.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/16/21.
//

import SwiftUI
import Firebase

@main
struct foodmenuApp: App {
    @StateObject var auth = Authentication()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            onBoardScreen()
                .environmentObject(auth)
        }
    }
}
