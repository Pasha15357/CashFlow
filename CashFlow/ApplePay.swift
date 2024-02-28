import SwiftUI
import PassKit

struct PaymentView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let paymentViewModel: PaymentViewModel

    class Coordinator: NSObject, PKPaymentAuthorizationViewControllerDelegate {
        var parent: PaymentView

        init(parent: PaymentView) {
            self.parent = parent
        }

        func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
            // Обработка успешной транзакции
            // Отправьте токен платежа на ваш сервер для финальной обработки

            // В данном примере, просто завершаем транзакцию
            let paymentAuthorizationResult = PKPaymentAuthorizationResult(status: .success, errors: nil)
            completion(paymentAuthorizationResult)
        }

        func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
            // Вызывается после завершения экрана оплаты (успешной или неуспешной)
            parent.isPresented = false
        }
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let hostingController = UIViewController() // Создаем UIViewController

        // Вставляем PKPaymentAuthorizationViewController как дочерний контроллер
        if let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentViewModel.paymentRequest) {
            paymentAuthorizationViewController.delegate = context.coordinator
            hostingController.addChild(paymentAuthorizationViewController)
            hostingController.view.addSubview(paymentAuthorizationViewController.view)
            paymentAuthorizationViewController.didMove(toParent: hostingController)
        }

        return hostingController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}


struct ApplePay: View {
    @State private var isPaymentViewPresented = false
    @StateObject private var paymentViewModel = PaymentViewModel()

    var body: some View {
        VStack {
            Button("Приобрести продукт") {
                isPaymentViewPresented.toggle()
            }
            .padding()
            .sheet(isPresented: $isPaymentViewPresented) {
                PaymentView(isPresented: $isPaymentViewPresented, paymentViewModel: paymentViewModel)
            }
        }
        .alert("Ошибка оплаты", isPresented: .init(get: { paymentViewModel.paymentError != nil }, set: { _ in
            paymentViewModel.paymentError = nil
        })) {
            Button("OK", role: .cancel) {}
        }
    }
} 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ApplePay()
    }
}

