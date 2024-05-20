import SwiftUI
import UIKit
import CoreData

struct ExportView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var exportSuccess: Bool = false
    @State private var showingAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("Export Data")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                exportData()
            }) {
                Text("Export")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(exportSuccess ? "Success" : "Error"),
                message: Text(exportSuccess ? "Data exported successfully." : "Failed to export data."),
                dismissButton: .default(Text("OK")) {
                    if exportSuccess {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
    
    func exportData() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        let viewController = ViewController()
        viewController.getExpenses()
        viewController.getIncomes()
        viewController.exportDatabase(from: rootViewController) { success in
            self.exportSuccess = success
            self.showingAlert = true
        }
    }
}

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel") // Замените на ваше имя модели данных
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

class ViewController: UIViewController {
    var fetchedExpenses: [NSManagedObject] = []
    var fetchedIncomes: [NSManagedObject] = []
    let context = CoreDataStack.shared.context
    @StateObject var settings = Settings1() // Создаем экземпляр Settings


    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the current data
        getExpenses()
        getIncomes()
    }

    func getExpenses() {
        // Fetch Expenses
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()

        do {
            // Get the results
            let searchResults = try context.fetch(fetchRequest)
            fetchedExpenses = searchResults as [NSManagedObject]
            // Log the results
            print("Number of expenses = \(searchResults.count)")
        } catch {
            print("Error with request: \(error)")
        }
    }

    func getIncomes() {
        // Fetch Incomes
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()

        do {
            // Get the results
            let searchResults = try context.fetch(fetchRequest)
            fetchedIncomes = searchResults as [NSManagedObject]
            // Log the results
            print("Number of incomes = \(searchResults.count)")
        } catch {
            print("Error with request: \(error)")
        }
    }

    func exportDatabase(from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let exportString = createExportString()
        saveAndExport(exportString: exportString, from: viewController, completion: completion)
    }

    func saveAndExport(exportString: String, from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let exportFilePath = NSTemporaryDirectory() + "transactions.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }

        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            fileHandle!.closeFile()

            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController: UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)

            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]

            viewController.dismiss(animated: true) {
                viewController.present(activityViewController, animated: true, completion: nil)
            
            }
        } else {
            completion(false)
        }
    }

    func createExportString() -> String {
        var export: String = NSLocalizedString("Баланс:,\(settings.selectedCurrency.sign)\(getUserBalance())\n\n", comment: "")

        // Export expenses header
        export += NSLocalizedString("Расходы\n", comment: "")
        export += NSLocalizedString("Сумма,Категория,Дата,Название\n", comment: "")
        
        // Export expenses
        for expense in fetchedExpenses {
            let amount = expense.value(forKey: "amount") as! Double
            let category = expense.value(forKey: "category") as! String
            let date = expense.value(forKey: "date") as! Date
            let name = expense.value(forKey: "name") as! String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: date)

            export += "\(settings.selectedCurrency.sign)\(amount),\(category),\(dateString),\(name)\n"
        }
        
        // Export incomes header
        export += NSLocalizedString("\n\nДоходы\n", comment: "")
        export += NSLocalizedString("Сумма,Категория,Дата,Название\n", comment: "")

        // Export incomes
        for income in fetchedIncomes {
            let amount = income.value(forKey: "amount") as! Double
            let category = income.value(forKey: "category") as! String
            let date = income.value(forKey: "date") as! Date
            let name = income.value(forKey: "name") as! String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: date)
            
            export += "\(settings.selectedCurrency.sign)\(amount),\(category),\(dateString),\(name)\n"
        }

        print("This is what the app will export: \(export)")
        return export
    }

    func getUserBalance() -> Double {
        let fetchRequest: NSFetchRequest<Balance> = Balance.fetchRequest()
        do {
            let balance = try context.fetch(fetchRequest).first?.amount ?? 0.0
            return balance
        } catch {
            print("Error fetching user balance: \(error)")
            return 0.0
        }
    }
}
