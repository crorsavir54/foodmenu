//
//  Home.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/30/21.
//

import SwiftUI
import Firebase

struct Home: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "signIn") as? Bool ?? false
    @State var anonLoginStatus = UserDefaults.standard.value(forKey: "anonymousSignIn") as? Bool ?? false
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack {
            VStack {
                if status {
                    LoggedIn(show: $show) //signout
                }
                if anonLoginStatus {
                    Login(show: $show) //link account
                }
                
                if auth.loggedOut {
                    onBoardScreen()
                }
            }
        }
        .onAppear {
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("signIn"), object: nil, queue: .main) {
                (_) in
                auth.getUser()
                self.status = UserDefaults.standard.value(forKey: "signIn") as? Bool ?? false
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("anonymousSignIn"), object: nil, queue: .main) {
                (_) in
                auth.getUser()
                self.anonLoginStatus = UserDefaults.standard.value(forKey: "anonymousSignIn") as? Bool ?? false
            }
        }
    }
}

struct LoggedIn: View {
    @EnvironmentObject var auth: Authentication

    @Binding var show: Bool
    var body: some View {
        VStack {
            Text("You are logged in as: ")
            Text(auth.userName)
                .fontWeight(.semibold)
            
            Button(action: {
                auth.status = .na
                auth.signOut()
                //                UserDefaults.standard.set(false, forKey: "anonymousSignIn")
                //                NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
                
            }, label: {
                Text("Log out")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width-50)
            }).background(Color.red)
                .cornerRadius(10)
                .padding(.top, 25)
        }.onAppear {
            auth.getUser()
//            auth.checkUser()
            
        }
    }
}
