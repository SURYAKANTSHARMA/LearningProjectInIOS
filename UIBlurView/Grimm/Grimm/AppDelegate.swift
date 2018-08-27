
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.themeDidChange), name: ThemeDidChangeNotification, object: nil)
    window!.tintColor = UIColor.blue
    return true
  }
  
  @objc func themeDidChange(){
    let theme = Theme.shared
    window!.tintColor = theme.tintColor
  }

}

