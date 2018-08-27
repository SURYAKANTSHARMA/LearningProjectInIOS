
import UIKit

enum Font: Int {
  case firaSans, notoSans, openSans, pztSans, sourceSansPro, system
}

enum ReadingMode: Int {
  case dayTime, nightTime
}

enum TitleAlignment: Int {
  case center, left
}

let ThemeDidChangeNotification = Notification.Name("ThemeDidChangeNotification")

protocol ThemeAdopting {
  func reloadTheme()
}

class Theme {
  
  static var shared = Theme()
  
  private let fonts = [
    ["FiraSans-Regular",
     "NotoSans",
     "OpenSans",
     "PTSans-Regular",
     "SourceSansPro-Regular"],
    ["FiraSans-SemiBold",
     "NotoSans-Bold",
     "OpenSans-Semibold",
     "PTSans-Bold",
     "SourceSansPro-Semibold"]
  ]
  
  private let textBackgroundColors = [UIColor.white, UIColor.nightTimeTextBackground]
  private let textColors = [UIColor.darkText, UIColor.nightTimeText]
  
  var font: Font = .firaSans {
    didSet{
      notifyObservers()
    }
  }
  
  var readingMode: ReadingMode = .dayTime {
    didSet {
      notifyObservers()
    }
  }
  var titleAlignment: TitleAlignment = .center {
    didSet {
      notifyObservers()
    }
  }
  
  var barTintColor: UIColor {
    let color = textBackgroundColors[readingMode.rawValue]
    return color.colorForTranslucency()
  }
  
  var tintColor: UIColor? {
    return readingMode == .dayTime ? nil : UIColor.nightTimeTint
  }
  
  var separatorColor: UIColor {
    return readingMode == .dayTime ? UIColor.defaultSeparator : UIColor.nightTimeTint
  }
  
  var textBackgroundColor: UIColor {
    return textBackgroundColors[readingMode.rawValue]
  }
  
  var textColor: UIColor {
    return textColors[readingMode.rawValue]
  }

  func preferredFont(forTextStyle style: UIFontTextStyle) -> UIFont {
    let systemFont = UIFont.preferredFont(forTextStyle: style)
    
    if font == .system {
      return systemFont
    }
    
    let size = systemFont.pointSize
    var preferredFont: UIFont
    
    if style == .headline {
      preferredFont = UIFont(name: fonts[1][font.rawValue], size: size)!
    } else {
      preferredFont = UIFont(name: fonts[0][font.rawValue], size: size)!
    }
    
    return preferredFont
  }
  
  private func notifyObservers() {
    NotificationCenter.default.post(name: ThemeDidChangeNotification, object: nil)
  }
  
}
