//
//  SignInAnonymously.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/30/21.
//

import SwiftUI
import Firebase

struct onBoardScreen: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "signIn") as? Bool ?? false
    @State var anonLoginStatus = UserDefaults.standard.value(forKey: "anonymousSignIn") as? Bool ?? false
    @State var isActive = false
    @EnvironmentObject var auth: Authentication
    
    
    var body: some View {
        NavigationView {
            VStack {
                if status == true || anonLoginStatus == true {
                    mainFoodMenu()
                }
                else {
                    signInAnonymously()
                }
            }
        }
        .fullScreenCover(isPresented: $auth.loggedOut, content: {
            signInAnonymously()
        })
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("anonymousSignIn"), object: nil, queue: .main) {
                (_) in
                self.anonLoginStatus = UserDefaults.standard.value(forKey: "anonymousSignIn") as? Bool ?? false
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("signIn"), object: nil, queue: .main) {
                (_) in
                self.status = UserDefaults.standard.value(forKey: "signIn") as? Bool ?? false
            }
        }
    }
}

struct signInAnonymously: View, KeyboardReadable {
    //    @Binding var show: Bool
    @EnvironmentObject var auth: Authentication
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @State var alert = false
    @State var error = ""
    @State var color = Color.black.opacity(0.7)
    @State var mainColor = Color.orange.opacity(0.9)
    @State var anonDisabled = false
    @State var isSignUpPresented = false
    @State var isKeyboardVisible = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .topTrailing) {
                GeometryReader { geometry in
                    VStack {
                        if !isKeyboardVisible {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .padding(.top, 10)
                                .frame(width: geometry.size.width/2, height: geometry.size.height/4)
                        }
                        Text("Already have an account?")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(color)
                        //                            .padding(.top, 10)
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? mainColor : color, lineWidth: 2))
                            .padding(.top, 15)
                            .onReceive(keyboardPublisher) { keyboardVisible in
                                withAnimation {
                                    isKeyboardVisible = keyboardVisible
                                }
                            }
                        HStack(spacing: 15) {
                            VStack {
                                if self.visible {
                                    TextField("Password", text: $pass)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Password", text: $pass)
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
                        .background(RoundedRectangle(cornerRadius: 4).stroke(email != "" ? mainColor: color, lineWidth: 2))
                        .padding(.top, 25)
                        HStack {
                            Spacer()
                            Button(action: {
                                //                                self.reset()
                            }, label: {
                                Text("Forgot password?")
                                //                                    .fontWeight(.bold)
                                    .foregroundColor(mainColor)
                            })
                        }
                        .padding(.top, 10)
                        VStack {
                            Button(action: {
                                auth.status = .na
                                auth.verify(email: email, pass: pass)
                            }, label: {
                                if auth.status == .na {
                                    ProgressView()
                                        .foregroundColor(.white)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width-50)
                                } else {
                                    Text("Log in")
                                        .foregroundColor(.white)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width-50)
                                }
                            }).background(mainColor)
                                .cornerRadius(10)
                                .padding(.top, 25)
                            if anonDisabled {
                                Text("Changing account without linking it with an account will permanently remove all data associated with this anonymous account")
                                    .font(.caption2)
                                Color.clear
                            } else {
                                Button(action: {
                                    withAnimation {
                                        auth.anonymousSignIn()
                                    }
                                    
                                }, label: {
                                    if auth.status == .na {
                                        ProgressView()
                                            .foregroundColor(.white)
                                            .padding(.vertical)
                                            .frame(width: UIScreen.main.bounds.width-50)
                                    } else {
                                        Text("Log in anonymously")
                                            .foregroundColor(.white)
                                            .padding(.vertical)
                                            .frame(width: UIScreen.main.bounds.width-50)
                                    }
                                    
                                }).background(Color.black.opacity(0.9))
                                    .cornerRadius(10)
                                    .padding(.top, 25)
                            }
                        }
                        Spacer()
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.black.opacity(0.7))
                            Button {
                                withAnimation {
                                    isSignUpPresented.toggle()
                                    
                                }
                                
                            } label: {
                                Text("Sign up")
                                    .foregroundColor(mainColor)
                                    .fontWeight(.semibold)
                            }
                        }.padding(.bottom, 10)
                    }.padding(.horizontal, 25)
                }
                .sheet(isPresented: $isSignUpPresented) {
                    SignUpView()
                }
                .alert(isPresented: $auth.showAlert) {
                    Alert(
                        title: Text("Login Error"),
                        message: Text(auth.errorMessage))
                }
            }
        }
    }
}
