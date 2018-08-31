
import UIKit

class ThemedNavigationController: UINavigationController, ThemeAdopting {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    NotificationCenter.default.addObserver(self, selector: #selector(ThemedNavigationController.reloadTheme), name: ThemeDidChangeNotification, object: nil)
  }
  
  @objc func reloadTheme() {
    let theme = Theme.shared
    navigationBar.barTintColor = theme.barTintColor
    view.tintColor = theme.tintColor
  }
  
}
