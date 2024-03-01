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


struct Registration1: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
        
        var body: some View {
            
            VStack{
                
                if status{
                    
                    Home()
                }
                else{
                    
                    SignIn()
                }
                
            }.animation(.spring())
                .onAppear {
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                        
                        let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                        self.status = status
                    }
            }
            
        }
}

func signInWithEmail(email: String, password : String, completion: @escaping
(Bool, String) ->Void) {
Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
    if err != nil {
        completion (false,(err?.localizedDescription)!)
        return

    }
    completion (true, (res?.user.email)!)
}
}

func signUpWithEmail (email: String, password : String, completion: @escaping
(Bool, String) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
        if err != nil  {
            completion (false,(err?.localizedDescription)!)
            return
        }
        completion (true,(res?.user.email)!)
    }
}

struct Home : View {
    @State private var firstName: String = ""
        @State private var lastName: String = ""
        @State private var birthday: Date = Date()
        @State private var isLoading = false

        var body: some View {
            Form {
                Section(header: Text("Личные данные")) {
                    TextField("Имя", text: $firstName)
                    TextField("Фамилия", text: $lastName)
                    DatePicker("Дата рождения", selection: $birthday, displayedComponents: .date)
                }

                Section {
                    Button(action: saveProfile) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Сохранить")
                        }
                    }
                    Button(action: {
                                    UserDefaults.standard.set(false, forKey: "status")
                                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                    
                                }) {
                                    
                                    Text("Выйти")
                                }
                }
            }
            .onAppear(perform: loadData)
            .navigationTitle("Профиль")
        }

        private func loadData() {
            guard let currentUser = Auth.auth().currentUser else { return }
            // Загрузка данных профиля пользователя из Firestore
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(currentUser.uid)

            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    firstName = data?["firstName"] as? String ?? ""
                    lastName = data?["lastName"] as? String ?? ""
                    if data?["birthday"] is String {
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "yyyy-MM-dd"
                        _ = dateFormatter.string(from: birthday)

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
            
            let userData: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "birthday": birthday
            ]
            
            userRef.setData(userData, merge: true) { error in
                if let error = error {
                    print("Ошибка сохранения профиля: \(error.localizedDescription)")
                } else {
                    print("Профиль успешно сохранен")
                }
            }
        }
    
}

struct SignIn : View {
    
    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var alert = false
    @State var show = false
    
    var body : some View{
        VStack {
            VStack{
                Text("Вход").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
                
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading){
                        
                        Text("Почта").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Введите ваш email", text: $user)
                            
                            if user != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Пароль").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        SecureField("Введите ваш пароль", text: $pass)
                        
                        Divider()
                    }
                    
                }.padding(.horizontal, 6)
                
                Button(action: {
                    
                    signInWithEmail(email: self.user, password: self.pass) { (verified, status) in
                        
                        if !verified {
                            
                            self.message = status
                            self.alert.toggle()
                        }
                        else{
                            
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        }
                    }
                    
                }) {
                    
                    Text("Войти").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                    
                    
                }.background(Color.green)
                    .clipShape(Capsule())
                    .padding(.top, 45)
                
            }.padding()
                .alert(isPresented: $alert) {
                    
                    Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
            }
            VStack{
                
                Text("(или)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)
                
                
                HStack(spacing: 8){
                    
                    Text("Нет аккаунта?").foregroundColor(Color.gray.opacity(0.5))
                    
                    Button(action: {
                        
                        self.show.toggle()
                        
                    }) {
                        
                        Text("Регистрация")
                        
                    }.foregroundColor(.blue)
                    
                }.padding(.top, 25)
                
            }.sheet(isPresented: $show) {
                
                SignUp(show: self.$show)
            }
        }
    }
}

struct SignUp : View {
    
    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var alert = false
    @Binding var show : Bool
    
    var body : some View{
        
        VStack{
            Text("Регистрация").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
            
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    
                    Text("Почта").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    
                    HStack{
                        
                        TextField("Введите ваш email", text: $user)
                        
                        if user != ""{
                            
                            Image("check").foregroundColor(Color.init(.label))
                        }
                        
                    }
                    
                    Divider()
                    
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading){
                    
                    Text("Пароль").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    
                    SecureField("Введите ваш пароль", text: $pass)
                    
                    Divider()
                }
                
            }.padding(.horizontal, 6)
            
            Button(action: {
                
                signUpWithEmail(email: self.user, password: self.pass) { (verified, status) in
                    
                    if !verified{
                        
                        self.message = status
                        self.alert.toggle()
                        
                    }
                    else{
                        
                        UserDefaults.standard.set(true, forKey: "status")
                        
                        self.show.toggle()
                        
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
                
            }) {
                
                Text("Зарегистрироваться").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                
                
            }.background(Color.green)
                .clipShape(Capsule())
                .padding(.top, 45)
            
        }.padding()
            .alert(isPresented: $alert) {
                
                Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    Registration1()
}
