//
//  SignUpView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/30/21.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @State var alert = false
    @State var error = ""
    @State var color = Color.black.opacity(0.7)
    @State var anonDisabled = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        ZStack {
            ZStack(alignment: .topTrailing) {
                GeometryReader { _ in
                    VStack {
                        Text("Register Account")
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
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    visible.toggle()
                                }} , label: {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            })
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.red : self.color, lineWidth: 2))
                        .padding(.top, 25)
                        VStack {
                            Button(action: {
                                withAnimation {
                                    auth.status = .na
                                    auth.signUp(email: email, pass: pass)
                                }
                                
                            }, label: {
                                if auth.status == .na {
                                    ProgressView()
                                        .foregroundColor(.white)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width-50)
                                } else {
                                    Text("Sign Up")
                                        .foregroundColor(.white)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width-50)
                                }

                            }).background(Color.orange)
                                .cornerRadius(10)
                                .padding(.top, 25)
                        }

                    }.padding(.horizontal, 25)
                }
            }
        }
        .alert(isPresented: $auth.showAlert) {
            Alert(
                title: Text("Sign up Error"),
                message: Text(auth.errorMessage))
        }
        
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
