//
//  Registration1.swift
//  CashFlow
//
//  Created by Паша on 29.02.24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices

struct Registration1: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        VStack {
            if status {
                Home()
            } else {
                SignIn()
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { _ in
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                self.status = status
            }
        }
    }
}

func signInWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { res, err in
        if let err = err {
            completion(false, err.localizedDescription)
            return
        }
        completion(true, res?.user.email ?? "")
    }
}

func signUpWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { res, err in
        if let err = err {
            completion(false, err.localizedDescription)
            return
        }
        completion(true, res?.user.email ?? "")
    }
}

struct Home: View {
    @State var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthday: Date = Date()
    @State private var isLoading = false
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                if let image = selectedImage {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Button("Выбрать изображение") {
                            showImagePicker.toggle()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(10)
                        Button("Удалить изображение") {
                            selectedImage = nil
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(10)
                    }
                } else {
                    VStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Button("Выбрать изображение") {
                            showImagePicker.toggle()
                        }
                    }
                }

                Section(header: Text("Имя")) {
                    TextField("Иван", text: $firstName)
                }
                Section(header: Text("Фамилия")) {
                    TextField("Иванов", text: $lastName)
                }
                Section {
                    DatePicker("Дата рождения", selection: $birthday, displayedComponents: .date)
                }

                Section {
                    HStack(alignment: .center) {
                        Button(action: {
                            saveProfile()
                            dismiss()
                        }) {
                            if isLoading {
                                ProgressView()
                            } else {
                                Text("Сохранить")
                            }
                        }
                    }
                    HStack(alignment: .center) {
                        Button(action: {
                            UserDefaults.standard.set(false, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        }) {
                            Text("Выйти")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .onAppear(perform: loadData)
            .navigationTitle("Данные профиля")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }

    func loadData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                firstName = data?["firstName"] as? String ?? ""
                lastName = data?["lastName"] as? String ?? ""
                if let timestamp = data?["birthday"] as? Timestamp {
                    birthday = timestamp.dateValue()
                } else {
                    birthday = Date()
                }
                if let imageData = data?["profileImage"] as? Data, let profileImage = UIImage(data: imageData) {
                    self.selectedImage = profileImage
                } else {
                    print("Profile image data not found")
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    private func saveProfile() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)

        var userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "birthday": Timestamp(date: birthday)
        ]

        if let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.5) {
            userData["profileImage"] = imageData
        } else {
            userData["profileImage"] = FieldValue.delete()
        }

        userRef.setData(userData, merge: true) { error in
            if let error = error {
                print("Ошибка сохранения профиля: \(error.localizedDescription)")
            } else {
                print("Профиль успешно сохранен")
            }
        }
    }
}

struct SignIn: View {
    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var alert = false
    @State var show = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Вход")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .padding([.top, .bottom], 20)
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Почта")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color(.label).opacity(0.75))
                        
                        HStack {
                            TextField("Введите ваш email", text: $user)
                            
                            if user != "" {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(.label))
                            }
                        }
                        
                        Divider()
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading) {
                        Text("Пароль")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color(.label).opacity(0.75))
                        
                        SecureField("Введите ваш пароль", text: $pass)
                        
                        Divider()
                    }
                }.padding(.horizontal, 6)
                
                Button(action: {
                    signInWithEmail(email: self.user, password: self.pass) { (verified, status) in
                        if !verified {
                            self.message = status
                            self.alert.toggle()
                        } else {
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        }
                    }
                }) {
                    Text("Войти")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 120)
                        .padding()
                }
                .background(Color.green)
                .clipShape(Capsule())
                .padding(.top, 45)
                
                SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                let userIdentifier = appleIDCredential.user
                                let email = appleIDCredential.email
                                let fullName = appleIDCredential.fullName
                                // Handle successful Apple ID sign-in here
                                // You may also want to save the userIdentifier in UserDefaults
                                UserDefaults.standard.set(true, forKey: "status")
                                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                            default:
                                break
                            }
                        case .failure(let error):
                            print("Authorization failed: \(error.localizedDescription)")
                        }
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(width: UIScreen.main.bounds.width - 120, height: 45)
                .padding(.top, 20)
            }
            .padding()
            .alert(isPresented: $alert) {
                Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var parent: SignIn
    
    init(parent: SignIn) {
        self.parent = parent
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = appleIDCredential.fullName
            // Handle successful Apple ID sign-in here
            // You may also want to save the userIdentifier in UserDefaults
            UserDefaults.standard.set(true, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
}

struct SignUp: View {
    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var alert = false
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            Text("Регистрация")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.top, .bottom], 20)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Почта")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color(.label).opacity(0.75))
                    
                    HStack {
                        TextField("Введите ваш email", text: $user)
                        
                        if user != "" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(.label))
                        }
                    }
                    
                    Divider()
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading) {
                    Text("Пароль")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color(.label).opacity(0.75))
                    
                    SecureField("Введите ваш пароль", text: $pass)
                    
                    Divider()
                }
            }.padding(.horizontal, 6)
            
            Button(action: {
                signUpWithEmail(email: self.user, password: self.pass) { (verified, status) in
                    if !verified {
                        self.message = status
                        self.alert.toggle()
                    } else {
                        UserDefaults.standard.set(true, forKey: "status")
                        self.show.toggle()
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
            }) {
                Text("Зарегистрироваться")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 120)
                    .padding()
            }
            .background(Color.green)
            .clipShape(Capsule())
            .padding(.top, 45)
        }
        .padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            picker.dismiss(animated: true)
        }
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

#Preview {
    Registration1()
}
