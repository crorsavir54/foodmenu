//
//  Authentication.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/30/21.
//

import Foundation
import Firebase

class Authentication: ObservableObject {
    
    func anonymousSignIn() {
        Auth.auth().signInAnonymously()
        UserDefaults.standard.set(true, forKey: "anonymousSignIn")
        NotificationCenter.default.post(name: NSNotification.Name("anonymousSignIn"), object: nil)
    }
    
    func verify(email: String, pass: String) {
        if email != "" && pass != "" {
            //For login
        let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
        
        Auth.auth().signIn(with: credential, completion: { (authresult, error) in
            if error != nil {
                print("error \(error?.localizedDescription)")
                return
            }
            print("success")
            UserDefaults.standard.set(true, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
        })
        }
        else {
            print("please fill properly")
        }
    }
    
    func link(email: String, pass: String) {

        if email != "" && pass != "" {
        let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
            
            Auth.auth().currentUser?.link(with: credential) { (res, error) in
                if error != nil {
                    print("error \(error?.localizedDescription)")
                    return
                }

                print("success linking account")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        else {
            print("please fill properly")
        }
    }
    
}
