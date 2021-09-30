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
    
    var body: some View {
        VStack {
            VStack {
                if status == true || anonLoginStatus == true {
                    mainFoodMenu()
                }
                else {
                    ZStack {
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) { //should be log-in account here
                            Text("")
                        }
                    }
                    .hidden()
                    signInAnonymously()
                }
            }
        }.navigationTitle("")
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

struct signInAnonymously: View {
//    @Binding var show: Bool
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @State var alert = false
    @State var error = ""
    @State var color = Color.black.opacity(0.7)
    @State var anonDisabled = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .topTrailing) {
                GeometryReader { _ in
                    VStack {
                        Text("Already have an account?")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
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
                            
                            Button(action: {self.visible.toggle()} , label: {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            })
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.red : self.color, lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack {
                            Spacer()
                            Button(action: {
//                                self.reset()
                            }, label: {
                                Text("Forget password")
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            })
                        }
                        .padding(.top, 20)
                        VStack {
                            Button(action: {
                                verify()
                            }, label: {
                                Text("Log in")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width-50)
                            }).background(Color.orange)
                                .cornerRadius(10)
                                .padding(.top, 25)

                            if anonDisabled {
                                Text("Changing account without linking your account will permanently remove all data associated with this anonymous account")
                                    .font(.caption2)
                                Color.clear
                            } else {
                                Button(action: {
                                    Auth.auth().signInAnonymously()
                                    UserDefaults.standard.set(true, forKey: "anonymousSignIn")
                                    UserDefaults.standard.set(false, forKey: "signIn")
                                    NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name("signIn"), object: nil)
                                    
                                    print("Signed in anonymously")
                                }, label: {
                                    Text("Log in anonymously")
                                        .foregroundColor(.white)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width-50)
                                }).background(Color.black.opacity(0.9))
                                    .cornerRadius(10)
                                    .padding(.top, 25)
                            }
                                
                            
                        }

                    }.padding(.horizontal, 25)
                }
            }
//            if self.alert {
//                ErrorView(alert: self.$alert, error: self.$error)
//            }
        }
        
    }
    
//    func anonymousSignIn () {
//        Auth.auth().signInAnonymously()
//
//    }
    
    func verify() {
        if self.email != "" && self.pass != "" {
            //For login
        let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.pass)
        
        Auth.auth().signIn(with: credential, completion: { (authresult, error) in
            if error != nil {
                print("error \(error?.localizedDescription)")
                return
            }
            print("success")
            UserDefaults.standard.set(false, forKey: "anonymousSignIn")
            UserDefaults.standard.set(true, forKey: "signIn")
            NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("signIn"), object: nil)
            
        })
        }
        else {
            self.error = "Please fill properly"
        }
    }
}
//struct SignInAnonymously_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInAnonymously()
//    }
//}
