import ReactiveSwift
import Result
import UIKit

struct Foo: Decodable {
    let foo: String
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var dataController: DataController!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Appearance.setup()

        dataController = DataController.shared
        dataController.load()

        return true
    }

    func applicationDidEnterBackground(_: UIApplication) {
        saveViewContext()
    }

    func applicationWillTerminate(_: UIApplication) {
        saveViewContext()
    }

    private func saveViewContext() {
        dataController.saveContext()
    }
}
