import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var show2FA = false
    @State private var verificationCode = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Phone Number (e.g., +1234567890)", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.phonePad)
            
            Button(action: {
                authViewModel.signIn(withEmail: email, password: password, phoneNumber: phoneNumber) { success in
                    if success {
                        show2FA = true
                    }
                }
            }) {
                Text("Sign In")
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#C67C4E"))
                    .cornerRadius(8)
            }
            .padding()
            
            if show2FA {
                TextField("2FA Code", text: $verificationCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    authViewModel.verify2FA(verificationCode: verificationCode)
                }) {
                    Text("Verify 2FA")
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#313131"))
                        .cornerRadius(8)
                }
                .padding()
            }
            
            NavigationLink(destination: SignUpView().environmentObject(authViewModel)) {
                Text("Create Account")
                    .foregroundColor(Color(hex: "#E3E3E3"))
            }
            .padding()
        }
        .navigationTitle("Login")
    }
}

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Phone Number (e.g., +1234567890)", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.phonePad)
            
            Button(action: {
                authViewModel.signUp(withEmail: email, password: password, phoneNumber: phoneNumber)
            }) {
                Text("Sign Up")
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#EDD6C8"))
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Sign Up")
    }
}

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }

    func signUp(withEmail email: String, password: String, phoneNumber: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to sign up: \(error.localizedDescription)")
                return
            }
            self.userSession = result?.user
            self.configure2FA(phoneNumber: phoneNumber)
            self.fetchUser()
        }
    }

    func signIn(withEmail email: String, password: String, phoneNumber: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to sign in: \(error.localizedDescription)")
                completion(false)
                return
            }
            self.userSession = result?.user
            self.configure2FA(phoneNumber: phoneNumber)
            self.fetchUser()
            completion(true)
        }
    }

    func configure2FA(phoneNumber: String) {
        let options = PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error sending 2FA code: \(error.localizedDescription)")
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
    }

    func verify2FA(verificationCode: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().currentUser?.link(with: credential) { result, error in
            if let error = error {
                print("2FA verification failed: \(error.localizedDescription)")
                return
            }
            self.fetchUser()
        }
    }

    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        // Fetch user data from Firebase Firestore if needed
    }

    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}
