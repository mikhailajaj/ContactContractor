//
//  LoginView.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//


import SwiftUI
import Amplify

struct LoginView: View {
    // 1
    @State var username: String = ""
    @State var password: String = ""
    // 2
    @State var shouldShowSignUp: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Sign in")
                    .font(.largeTitle)
                    .bold()
                // 3
                VStack{
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                Button("Log In") {
                    Task { await login() }
                }
                .buttonStyle(.borderedProminent)
                .padding()

                Spacer()
                Button("Don't have an account? Sign up.", action: { shouldShowSignUp = true })
                    .padding()

                
            }
            // 4
            .navigationDestination(isPresented: $shouldShowSignUp) {
                SignUpView(showLogin: { shouldShowSignUp = false })
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    func login() async {
        do {
            // 1
            let result = try await Amplify.Auth.signIn(
                username: username,
                password: password
            )
            switch result.nextStep {
            // 2
            case .done:
                print("login is done")
            default:
                print(result.nextStep)
            }
        } catch {
            print(error)
        }
    }
}
