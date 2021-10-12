//
//  Authentication.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/30/21.
//

import Foundation
import Firebase
import SwiftUI

class Authentication: ObservableObject {
    @Published var userName = ""
    @Published var errorMessage = ""
    @Published var status = authStatus.failed
    @Published var showAlert = false
    @Published var loggedOut = false
    
    enum authStatus: String {
        case na
        case succes
        case failed
    }
//    func checkUser() {
//        if Auth.auth().currentUser != nil {
//            return
//        } else {
//            self.anonymousSignIn()
//        }
//    }
    
    func getUser() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                if user.isAnonymous {
                    self.userName = "AnonID: \(user.uid)"
                } else {
                    guard let email = user.email else {
                       
                        print("Can't get email")
                        return
                    }
                    self.userName = email
                }
            } else {
                print("No signed in user")
            }
        }
    }
    
    func anonymousSignIn() {
        Auth.auth().signInAnonymously()
        self.status = .succes
        self.loggedOut = false
        UserDefaults.standard.set(true, forKey: "anonymousSignIn")
        UserDefaults.standard.set(false, forKey: "signIn")
        NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("signIn"), object: nil)
        print("Signed in anonymously")
    }
    
    func verify(email: String, pass: String) {
        
        if email != "" && pass != "" {
            //For login
        let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
        
        Auth.auth().signIn(with: credential, completion: { (authresult, error) in
            if error != nil {
                self.status = .failed
                self.errorMessage = error!.localizedDescription
                print(self.errorMessage)
                print(self.status)
                self.showAlert = true
                return
            }
            print("success")
            self.status = .succes
            self.loggedOut = false
            UserDefaults.standard.set(false, forKey: "anonymousSignIn")
            UserDefaults.standard.set(true, forKey: "signIn")
            NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("signIn"), object: nil)
            
        })
        }
        else {
            self.status = .failed
            self.showAlert = true
            errorMessage = "Please input fields"
        }
    }
    
    func link(email: String, pass: String) {
        
        if email != "" && pass != "" {
            let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
            Auth.auth().currentUser?.link(with: credential) { (res, error) in
                if error != nil {
                    self.errorMessage = error!.localizedDescription
                    self.showAlert = true
                    self.status = .failed
                    print("Error login")
                    return
                }
  
                self.status = .succes
                print("success linking account")
                UserDefaults.standard.set(false, forKey: "anonymousSignIn")
                UserDefaults.standard.set(true, forKey: "signIn")
                NotificationCenter.default.post(name: NSNotification.Name("signIn"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
            }
        }
        else {
            self.status = .failed
            self.showAlert = true
            errorMessage = "Please input fields"
        }
    }
    
    func signUp(email: String, pass: String) {
        if email != "" && pass != "" {
            Auth.auth().createUser(withEmail: email, password: pass, completion: { (authresult, error) in
            if error != nil {
                self.errorMessage = error!.localizedDescription
                self.showAlert = true
                self.status = .failed
                print("Signup Error")
                return
            }
            self.status = .succes
            print("success")
        })
        }
        else {
            self.status = .failed
            self.showAlert = true
            errorMessage = "Please input fields"
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            self.status = .succes

        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            
            self.status = .failed
        }
        self.loggedOut = true
        
        UserDefaults.standard.set(false, forKey: "signIn")
        NotificationCenter.default.post(name: NSNotification.Name("signIn"), object: nil)
        UserDefaults.standard.set(false, forKey: "anonymousSignIn")
        NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
       
    }
}
