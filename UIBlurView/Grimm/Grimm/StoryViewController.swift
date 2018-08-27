
import UIKit

class StoryViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var storyView: StoryView!
  @IBOutlet weak var optionsContainerView: UIView!
  @IBOutlet weak var optionsContainerViewBottomConstraint: NSLayoutConstraint!
  
  private var showingOptions = false
  
  var story: Story?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    NotificationCenter.default.addObserver(self, selector: #selector(StoryViewController.themeDidChange), name: ThemeDidChangeNotification, object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let image = UIImage(named: "Bull")
    let imageView = UIImageView(image: image)
    navigationItem.titleView = imageView
    reloadTheme()
    guard let story = story else {
      fatalError("Missing critical dependencies!")
    }
    storyView.story = story
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setOptionsHidden(true, animated: false)
  }
  
  @IBAction func optionsButtonTapped() {
    setOptionsHidden(showingOptions, animated: true)
  }
  
  private func setOptionsHidden(_ hidden: Bool, animated: Bool) {
    showingOptions = !hidden
    let height = optionsContainerView.bounds.height
    var constant = optionsContainerViewBottomConstraint.constant
    constant = hidden ? (constant - height) : (constant + height)
    view.layoutIfNeeded()
    
    if animated {
      UIView.animate(withDuration: 0.2,
                                 delay: 0,
                                 usingSpringWithDamping: 0.95,
                                 initialSpringVelocity: 1,
                                 options: [.allowUserInteraction,
                                           .beginFromCurrentState],
                                 animations: {
                                  self.optionsContainerViewBottomConstraint.constant = constant
                                  self.view.layoutIfNeeded()
      }, completion: nil)
    } else {
      optionsContainerViewBottomConstraint.constant = constant
    }
  }
  
  @objc func themeDidChange() {
    reloadTheme()
    storyView.reloadTheme()
  }
  
}

extension StoryViewController: ThemeAdopting {
  func reloadTheme() {
    let theme = Theme.shared
    scrollView.backgroundColor = theme.textBackgroundColor
    for viewController in childViewControllers {
      viewController.view.tintColor = theme.tintColor
    }
  }
}
