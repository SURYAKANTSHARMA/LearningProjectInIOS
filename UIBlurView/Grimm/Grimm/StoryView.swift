
import UIKit

class StoryView: UIView, ThemeAdopting {
  
  override func awakeFromNib() {
    reloadTheme()
  }
  
  var story: Story? {
    didSet {
      titleLabel.text = story!.title
      contentLabel.text = story!.content
      setNeedsUpdateConstraints()
    }
  }
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var contentLabel: UILabel!
  @IBOutlet var separatorView: UIView!
  
  func reloadTheme()  {
    let theme = Theme.shared
    backgroundColor = theme.textBackgroundColor
    
    titleLabel.backgroundColor = theme.textBackgroundColor
    titleLabel.font = theme.preferredFont(forTextStyle: .headline)
    titleLabel.textColor = theme.textColor
    titleLabel.textAlignment = theme.titleAlignment == TitleAlignment.center ? NSTextAlignment.center : NSTextAlignment.left
    
    contentLabel.backgroundColor = theme.textBackgroundColor
    contentLabel.font = theme.preferredFont(forTextStyle: .body)
    contentLabel.textColor = theme.textColor
    
    separatorView.backgroundColor = theme.separatorColor
  }
  
}
