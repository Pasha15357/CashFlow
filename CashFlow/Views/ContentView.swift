//
//  ContentView.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

import SwiftUI
import LocalAuthentication
import GoogleMobileAds


struct ContentView: View {
    @State public var selectedView = 1
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    @AppStorage("isFaceIDOn") private var isFaceIDOn: Bool = false
    @State private var isAuthenticated = false

    var body: some View {
//        BannerAdView()
//                        .frame(width: UIScreen.main.bounds.width, height: GADAdSizeBanner.size.height)
//                    Spacer()
        Group {
            if isAuthenticated || !isFaceIDOn {
                TabView(selection: $selectedView) {
                    Main(selectedView: $selectedView)
                        .tabItem {
                            Image(systemName: (self.selectedView == 1 ? "house" : "house.fill"))
                            Text("Главная")
                        }
                        .tag(1)
                    ListOfExpenses()
                        .tabItem {
                            Image(systemName: (self.selectedView == 2 ? "minus.rectangle" : "minus.rectangle"))
                            Text("Расходы")
                        }
                        .tag(2)
                    ListOfIncomes()
                        .tabItem {
                            Image(systemName: (self.selectedView == 3 ? "plus.rectangle" : "plus.rectangle"))
                            Text("Доходы")
                        }
                        .tag(3)
                    Diagram()
                        .tabItem {
                            Image(systemName: (self.selectedView == 4 ? "chart.bar.xaxis.ascending" : "chart.bar.xaxis.ascending"))
                            Text("Статистика")
                        }
                        .tag(4)
                    Settings()
                        .tabItem {
                            Image(systemName: (self.selectedView == 5 ? "gearshape" : "gearshape.fill"))
                            Text("Настройки")
                        }
                        .tag(5)
                }
            } else {
                ZStack {
                    if isDarkModeOn {
                        Color.black.edgesIgnoringSafeArea(.all)
                    } else {
                        Color.white.edgesIgnoringSafeArea(.all)
                    }

                    VStack (alignment: .center) {
                        HStack (alignment: .center) {
                            
                            Text("Чтобы открыть приложение, используйте Face ID")
                                .foregroundColor(isDarkModeOn ? .white : .black)
                                .padding(.bottom, 20)
                                .font(.title)
                                .bold()
                            .frame(maxWidth: 300, alignment: .center)
                            
                        }


                        Button(action: {
                            authenticateWithFaceID { success in
                                isAuthenticated = success
                                if !success {
                                    // Обработка отказа в аутентификации
                                    print("Открыть приложение")
                                }
                            }
                        }) {
                            Text("Повторить вход")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .onAppear {
                    authenticateWithFaceID { success in
                        isAuthenticated = success
                        if !success {
                            // Обработка отказа в аутентификации
                            print("Face ID authentication failed on app start")
                        }
                    }
                }
            }
        }
    }

    private func authenticateWithFaceID(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Пожалуйста, аутентифицируйтесь для доступа к приложению"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("Face ID authentication succeeded")
                    } else {
                        print("Face ID authentication failed: \(String(describing: authenticationError))")
                    }
                    completion(success)
                }
            }
        } else {
            print("Face ID not available: \(String(describing: error))")
            completion(false)
        }
    }
}


struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = "ca-app-pub-6439374118527054/1521147724" // замените на ваш идентификатор рекламного блока
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // Обновите представление при необходимости
    }
}





#Preview {
    ContentView()
}
