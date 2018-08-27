
import UIKit

class StoryCell: UITableViewCell, ThemeAdopting {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String!)  {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  var story: Story? {
    didSet {
      guard let story = story else { return }
      titleLabel.text = story.title
      previewLabel.text = story.content
      reloadTheme()
      setNeedsUpdateConstraints()
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.isOpaque = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
    }()
  
  private var previewLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 3
    label.isOpaque = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
    }()
  
  func reloadTheme()  {
    let theme = Theme.shared
    
    backgroundColor = theme.textBackgroundColor
    contentView.backgroundColor = theme.textBackgroundColor
    
    titleLabel.backgroundColor = theme.textBackgroundColor
    titleLabel.font = theme.preferredFont(forTextStyle: .headline)
    titleLabel.textColor = theme.textColor
    
    previewLabel.backgroundColor = theme.textBackgroundColor
    previewLabel.font = theme.preferredFont(forTextStyle: .body)
    previewLabel.textColor = theme.textColor
  }
  
  private func setup() {
    let stackView = UIStackView(arrangedSubviews: [titleLabel, previewLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 8.0
    stackView.axis = .vertical
    
    contentView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
      stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
      stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
      contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64)
      ])
    
    reloadTheme()
  }
}
