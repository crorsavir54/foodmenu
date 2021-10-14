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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            VStack {
                if auth.loggedOut {
                    onBoardScreen()
                }
                else if status && !anonLoginStatus {
                    LoggedIn(show: $show) //signout
                }
                else if anonLoginStatus && !status {
                    Login(show: $show) //link account
                }
                else {
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
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var show: Bool
    var body: some View {
        VStack {
            Text("You are logged in as: ")
            Text(auth.userName)
                .fontWeight(.semibold)
            
            Button(action: {
                withAnimation {
                    auth.status = .na
                    auth.signOut()
                    presentationMode.wrappedValue.dismiss()
                }
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
