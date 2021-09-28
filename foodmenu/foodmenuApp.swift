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
    
    init() {
        FirebaseApp.configure()
        Auth.auth().signInAnonymously()
    }
    
    var body: some Scene {
        WindowGroup {
            mainFoodMenu()
        }
    }
}
