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
//                    ZStack {
//                        NavigationLink(destination: LoggedIn(show: self.$show), isActive: self.$show) {
//                            Text("")
//                        }
//                    }
//                    .hidden()
                    mainFoodMenu()
                }
            }
        }
//            .navigationBarHidden(true)
//            .navigationBarBackButtonHidden(true)
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("signIn"), object: nil, queue: .main) {
                    (_) in
                    self.status = UserDefaults.standard.value(forKey: "signIn") as? Bool ?? false
                }
                NotificationCenter.default.addObserver(forName: NSNotification.Name("anonymousSignIn"), object: nil, queue: .main) {
                    (_) in
                    self.anonLoginStatus = UserDefaults.standard.value(forKey: "anonymousSignIn") as? Bool ?? false
                }
            }
    }
}



struct LoggedIn: View {
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
            Text("You are logged in")
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
        }
    }
}

struct Login: View {
    @Binding var show: Bool
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @State var alert = false
    @State var error = ""
    @State var color = Color.black.opacity(0.7)
    @State var logInViewPresented = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .topTrailing) {
                GeometryReader { _ in
                    VStack {
                        HStack {
                            Text("Sign up and link an account")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(self.color)
                                .padding(.top, 35)
//                                .padding(.horizontal, 20)
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
                            
                            Button(action: {self.visible.toggle()} , label: {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            })
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.red : self.color, lineWidth: 2))
                        .padding(.top, 25)
                            Button(action: {
                                link()
                                show.toggle()
                            }, label: {
                                Text("Link")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width-50)
                            }).background(Color.orange)
                                .cornerRadius(10)
                                .padding(.top, 25)
                        Text("Already have an account?")
                            .foregroundColor(.black.opacity(0.7))
                            .onTapGesture {
                                logInViewPresented.toggle()
                            }
                    }.sheet(isPresented: $logInViewPresented) {
                        signInAnonymously(anonDisabled: true)
                    }

                    }.padding(.horizontal, 25)
                }
            }
        }
    
    func link() {
        if self.email != "" && self.pass != "" {
        let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.pass)
            
            Auth.auth().currentUser?.link(with: credential) { (res, err) in
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                print("success linking account")


                UserDefaults.standard.set(true, forKey: "signIn")
                NotificationCenter.default.post(name: NSNotification.Name("signIn"), object: nil)
                UserDefaults.standard.set(false, forKey: "anonymousSignIn")
                NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
            }
        }
        else {
            self.error = "Please fill properly"
        }
    }
    
//    func verify() {
//        if self.email != "" && self.pass != "" {
//            //For login
//        let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.pass)
//
//        Auth.auth().signIn(with: credential, completion: { (authresult, error) in
//            if error != nil {
//                print("error \(error?.localizedDescription)")
//                return
//            }
//            print("success")
//            UserDefaults.standard.set(true, forKey: "status")
//            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
//        })
//        }
//        else {
//            self.error = "Please fill properly"
//        }
//    }
}


struct SignUp: View {
    @Binding var show: Bool
    var body: some View {
        Text("SignUp")
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}
