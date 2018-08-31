
import UIKit

extension UIColor {
    
  func colorForTranslucency() -> UIColor {
    
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    
    self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }
  
  class func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
  }
  
  class var defaultSeparator: UIColor {
    return .rgba(red: 200, green: 199, blue: 204, alpha: 1)
  }
  
  class var nightTimeTextBackground: UIColor {
    return .rgba(red: 245, green: 238, blue: 220, alpha: 1)
  }
  
  class var nightTimeText: UIColor {
    return .rgba(red: 50, green: 20, blue: 0, alpha: 1)
  }
  
  class var nightTimeTint: UIColor {
    return .rgba(red: 182, green: 126, blue: 44, alpha: 1)
  }
}
