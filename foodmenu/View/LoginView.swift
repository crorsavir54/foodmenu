//
//  LoginView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 10/6/21.
//

import SwiftUI

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
                            auth.status = .na
                            auth.link(email: email, pass: pass)
                        }, label: {
                            if auth.status == .na {
                                ProgressView()
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width-50)

                            } else {
                                Text("Link")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width-50)
                            }
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
                    .alert(isPresented: $auth.showAlert) {
                        Alert(
                            title: Text("Login Error"),
                            message: Text(auth.errorMessage))
                    }
                    
                    
                }.padding(.horizontal, 25)
            }
        }
    }
}
