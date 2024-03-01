//
//  Registration.swift
//  CashFlow
//
//  Created by Паша on 24.11.23.
//

import SwiftUI
import FirebaseCore

struct Registration: View {
    @State var index = 0
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                Image("Nike")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                
                ZStack {
//                    SignUp(index: self.$index)
//                        .zIndex(Double(self.index))
                    Login(index: self.$index)
                }
                
                HStack (spacing: 15){
                    Rectangle()
                        .fill(Color("Color1"))
                        .frame(height: 1)
                    
                    Text("OR")
                    
                    Rectangle()
                        .fill(Color("Color1"))
                        .frame(height: 1)
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                
                HStack (spacing: 25){
                    Button(action: {
                        
                    }) {
                        Image("AppleLogo")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    Button(action: {
                        
                    }) {
                        Image("Facebook")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    Button(action: {
                        
                    }) {
                        Image("Twitter")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 30)
            }
            .padding(.vertical)
        }

        
    }
}

#Preview {
    Registration()
}

struct CShape : Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

struct CShape1 : Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}

struct Login: View {
    @State var email = ""
    @State var pass = ""
    @Binding var index : Int
    
    var body: some View {
        ZStack (alignment: .bottom) {
            VStack {
                HStack {
                    VStack (spacing: 10) {
                        Text("Login")
                            .foregroundColor(self.index == 0 ? .black : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        Capsule()
                            .fill(self.index == 0 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                    
                    Spacer()
                }
                .padding(.top, 30)
                
                VStack {
                    HStack (spacing: 15){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color("Color1"))
                        TextField("Email Address", text: self.$email)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack {
                    HStack (spacing: 15){
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Color1"))
                        SecureField("Password", text: self.$pass)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                HStack {
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        
                    }) {
                        Text("Forget Password?")
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)

            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("Color2"))
            .clipShape(CShape())
            .contentShape(CShape())
            
            .onTapGesture {
                self.index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            
            
            Button(action: {
                
            }) {
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("Color1"))
                    .clipShape(Capsule())
                    .shadow(color: .white.opacity(0.1), radius: 5, x: 0, y: -5)
            }
            .offset(y: 25)
            .opacity(self.index == 0 ? 1 : 0)
        }
    }
}

//struct SignUp: View {
//    @State var email = ""
//    @State var pass = ""
//    @State var repass = ""
//    @Binding var index : Int
//    
//    var body: some View {
//        ZStack (alignment: .bottom){
//            VStack {
//                HStack {
//                    Spacer(minLength: 0)
//                    
//                    VStack(spacing: 10) {
//                        Text("SignUp")
//                            .foregroundColor(self.index == 1 ? .black : .gray)
//                            .font(.title)
//                            .fontWeight(.bold)
//                        
//                        Capsule()
//                            .fill(self.index == 1 ? Color.blue : Color.clear)
//                            .frame(width: 100, height: 5)
//                    }
//                }
//                .padding(.top, 30)
//                
//                VStack {
//                    HStack(spacing: 15) {
//                        Image(systemName: "envelope.fill")
//                            .foregroundColor(Color("Color1"))
//                        TextField("Email Address", text: self.$email)
//                    }
//                    Divider().background(Color.white.opacity(0.5))
//                }
//                .padding(.horizontal)
//                .padding(.top, 40)
//                
//                VStack {
//                    HStack (spacing: 15){
//                        Image(systemName: "eye.slash.fill")
//                            .foregroundColor(Color("Color1"))
//                        SecureField("Password", text: self.$pass)
//                    }
//                    Divider()
//                        .background(Color.white.opacity(0.5))
//                }
//                .padding(.horizontal)
//                .padding(.top, 30)
//                
//                VStack {
//                    HStack(spacing: 15) {
//                        Image(systemName: "eye.slash.fill")
//                            .foregroundColor(Color("Color1"))
//                        SecureField("Password", text: self.$repass)
//                    }
//                    
//                    Divider().background(Color.white.opacity(0.5))
//                }
//                .padding(.horizontal)
//                .padding(.top, 30)
//            }
//            .padding()
//            .padding(.bottom, 65)
//            .background(Color("Color2"))
//            .clipShape(CShape1())
//            .contentShape(CShape1())
//            
//            .onTapGesture {
//                self.index = 1
//            }
//            .cornerRadius(35)
//            .padding(.horizontal, 20)
//            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: -5)
//            
//            
//            Button(action: {
//                
//            }) {
//                Text("SIGNUP")
//                    .foregroundColor(.white)
//                    .fontWeight(.bold)
//                    .padding(.vertical)
//                    .padding(.horizontal, 50)
//                    .background(Color("Color1"))
//                    .clipShape(Capsule())
//                    .shadow(color: .white.opacity(0.1), radius: 5, x: 0, y: -5)
//            }
//            .offset(y: 25)
//            .opacity(self.index == 1 ? 1 : 0)
//        }
//
//    }
//}

