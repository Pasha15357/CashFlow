import SwiftUI
import PassKit

class PaymentViewModel: ObservableObject {
    @Published var paymentError: Error?
    var paymentRequest: PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "your_merchant_identifier" // Замените на ваш реальный идентификатор
        paymentRequest.supportedNetworks = [.amex, .masterCard, .visa]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.merchantIdentifier = "merchant.yourapp" // Замените на ваш реальный идентификатор
        
        // Используйте тестовые данные для симуляции платежа
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Пример продукта", amount: NSDecimalNumber(decimal: 1.00)),
            PKPaymentSummaryItem(label: "Налог", amount: NSDecimalNumber(decimal: 0.10))
        ]

        return paymentRequest
    }

    func purchaseProduct() {
        // Добавьте код для обработки покупки
    }
}
