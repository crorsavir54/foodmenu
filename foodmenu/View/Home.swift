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
                
                if status == false && anonLoginStatus == false {
                    mainFoodMenu()
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
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.set(false, forKey: "signIn")
        NotificationCenter.default.post(name: NSNotification.Name("signIn"), object: nil)
        UserDefaults.standard.set(false, forKey: "anonymousSignIn")
        NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
        Auth.auth().signInAnonymously()
        UserDefaults.standard.set(true, forKey: "anonymousSignIn")
        UserDefaults.standard.set(false, forKey: "signIn")
        NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("signIn"), object: nil)
    }
    @Binding var show: Bool
    var body: some View {
        VStack {
            Text("You are logged in as: ")
            Text(auth.userName)
                .fontWeight(.semibold)
            Button(action: {
                signOut()
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
        }
    }
}

struct Login: View {
    @EnvironmentObject var auth: Authentication
    @Binding var show: Bool
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @State var alert = false
    @State var error = ""
    @State var color = Color.black.opacity(0.7)
    @State var mainColor = Color.orange.opacity(0.9)
    @State var logInViewPresented = false
    @State var isSignUpPresented = false
    
    
    var body: some View {
        ZStack {
            ZStack(alignment: .topTrailing) {
                GeometryReader { _ in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Sign up and link an account")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(self.color)
                                    .padding(.top, 35)
                                //                                .padding(.horizontal, 20)
                                Text("You are signed in as \(auth.userName). To store and retain your info, you can link it to an account")
                                    .font(.caption2)
                            }
                            Spacer()
                        }

                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.red : self.color, lineWidth: 2))
                            .padding(.top, 25)
                        HStack(spacing: 15) {
                            VStack {
                                if self.visible {
                                    TextField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    visible.toggle()
                                }
                            } , label: {
                                Image(systemName: visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(mainColor)
                            })
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? mainColor : self.color, lineWidth: 2))
                        .padding(.top, 25)
                        Button(action: {
                            auth.link(email: email, pass: pass)
                            show.toggle()
                        }, label: {
                            Text("Link")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width-50)
                        }).background(Color.orange)
                            .cornerRadius(10)
                            .padding(.top, 25)
                        Spacer()
                        VStack {
//                            Button(action: {
//                                isSignUpPresented.toggle()
//                            }, label: {
//                                HStack {
//                                    Text("Want to sign up first before linking?")
//                                        .foregroundColor(.black.opacity(0.7))
//                                    Text("Sign up")
//                                        .fontWeight(.semibold)
//                                        .foregroundColor(.orange.opacity(0.7))
//                                }
//                            })
                            HStack {
                                Text("Already have an account?")
                                    .foregroundColor(.black.opacity(0.7))
                                Text("Login")
                                    .foregroundColor(mainColor)
                                    .fontWeight(.semibold)
                                    .onTapGesture {
                                        logInViewPresented.toggle()
                                    }
                            }
                        }
                    }.onAppear {
                        auth.getUser()
                        
                    }
                    .sheet(isPresented: $logInViewPresented) {
                        signInAnonymously(anonDisabled: true)
                    }
                    .sheet(isPresented: $isSignUpPresented) {
                        SignUpView()
                    }
                    
                    
                }.padding(.horizontal, 25)
            }
        }
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}
