//
//  Toast.swift
//  CashFlow
//
//  Created by Паша on 30.07.24.
//

//import SwiftUI
//
//struct ToastView: View {
//    var message: String
//    var onDismiss: () -> Void
//
//    @State private var offset: CGSize = .zero
//
//    var body: some View {
//        VStack {
//            Spacer()
//            Text(message)
//                .font(.body)
//                .padding()
//                .background(Color.black.opacity(0.8))
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                .shadow(radius: 10)
//                .padding()
//                .offset(y: offset.height)
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            self.offset = gesture.translation
//                        }
//                        .onEnded { _ in
//                            if self.offset.height > 50 {
//                                withAnimation {
//                                    self.onDismiss()
//                                }
//                            } else {
//                                self.offset = .zero
//                            }
//                        }
//                )
//        }
//        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
//    }
//}
//
//
//struct ToastModifier: ViewModifier {
//    @Binding var isShowing: Bool
//    let message: String
//    let duration: TimeInterval = 3.0
//
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            if isShowing {
//                ToastView(message: message) {
//                    withAnimation {
//                        isShowing = false
//                    }
//                }
//                .zIndex(1)
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//                        withAnimation {
//                            isShowing = false
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//extension View {
//    func toast(isShowing: Binding<Bool>, message: String) -> some View {
//        self.modifier(ToastModifier(isShowing: isShowing, message: message))
//    }
//}


