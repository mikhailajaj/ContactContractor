//
//  SignUpView.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//


import SwiftUI
import Amplify

struct SignUpView: View {
    // 1
    let showLogin: () -> Void
    
    @State var username: String = ""
    // 2
    @State var email: String = ""
    @State var password: String = ""
    @State var shouldShowConfirmSignUp: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Sign up")
                .font(.largeTitle)
                .bold()
            VStack{
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
            }
            .padding()
            Button("Sign Up") {
                Task { await signUp() }
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Spacer()
            Button("Already have an account? Login.", action: showLogin)
                .padding()

        }
        // 3
        .navigationDestination(isPresented: .constant(shouldShowConfirmSignUp)) {
            ConfirmSignUpView(username: username)
        }
    }
    func signUp() async {
        // 1
        let options = AuthSignUpRequest.Options(
            userAttributes: [.init(.email, value: email)]
        )
        do {
            // 2
            let result = try await Amplify.Auth.signUp(
                username: username,
                password: password,
                options: options
            )
            
            switch result.nextStep {
            // 3
            case .confirmUser:
                DispatchQueue.main.async {
                    self.shouldShowConfirmSignUp = true
                }
            default:
                print(result)
            }
        } catch {
            print(error)
        }
    }
}
