
import UIKit

class OptionsController: UIViewController {
  
  private var currentPage = 0
  @IBOutlet weak var readingModeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var titleAlignmentSegmentedControl: UISegmentedControl!
  @IBOutlet weak var pageControl: UIPageControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let optionsView = UINib(nibName: "OptionsView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
    scrollView.scrollsToTop = false
    
    guard UIAccessibilityIsReduceTransparencyEnabled() == false else {
        view.addSubview(optionsView)
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: optionsView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: optionsView.centerYAnchor)
            ])
        
        return
    }

//    view.addSubview(optionsView)
//    NSLayoutConstraint.activate([
//      view.centerXAnchor.constraint(equalTo: optionsView.centerXAnchor),
//      view.centerYAnchor.constraint(equalTo: optionsView.centerYAnchor)
//      ])
     // add blur view
     view.backgroundColor = .clear
     let blurEffect = UIBlurEffect(style: .light)
     let blurView = UIVisualEffectView(effect: blurEffect)
    
     let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
     let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
     vibrancyView.translatesAutoresizingMaskIntoConstraints = false
    
     vibrancyView.contentView.addSubview(optionsView)
     blurView.contentView.addSubview(vibrancyView)
    
     blurView.translatesAutoresizingMaskIntoConstraints = false
     view.insertSubview(blurView, at: 0)
    
     NSLayoutConstraint.activate([
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    
    NSLayoutConstraint.activate([
        vibrancyView.heightAnchor.constraint(equalTo: blurView.contentView.heightAnchor),
        vibrancyView.widthAnchor.constraint(equalTo: blurView.contentView.widthAnchor),
        vibrancyView.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
        vibrancyView.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor)
        ])
    NSLayoutConstraint.activate([
        optionsView.centerXAnchor.constraint(equalTo: vibrancyView.contentView.centerXAnchor),
        optionsView.centerYAnchor.constraint(equalTo: vibrancyView.contentView.centerYAnchor),
        ])
    
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let theme = Theme.shared
    readingModeSegmentedControl.selectedSegmentIndex = theme.readingMode.rawValue
    titleAlignmentSegmentedControl.selectedSegmentIndex = theme.titleAlignment.rawValue
    currentPage = theme.font.rawValue
    pageControl.currentPage = currentPage
    synchronizeViews(scrolled: false)
  }
  
  @IBAction func pageControlPageDidChange() {
    synchronizeViews(scrolled: false)
  }
  
  @IBAction func readingModeDidChange(_ segmentedControl: UISegmentedControl) {
    Theme.shared.readingMode = ReadingMode(rawValue: segmentedControl.selectedSegmentIndex) ?? .dayTime
  }
  
  @IBAction func titleAlignmentDidChange(_ segmentedControl: UISegmentedControl) {
    Theme.shared.titleAlignment = TitleAlignment(rawValue: segmentedControl.selectedSegmentIndex) ?? .left
  }
  
  private func synchronizeViews(scrolled: Bool) {
    let pageWidth = scrollView.bounds.width
    var page: Int = 0
    var offset: CGFloat = 0
    
    if scrolled {
      offset = scrollView.contentOffset.x
      page = Int(offset / pageWidth)
      pageControl.currentPage = page
    } else {
      page = pageControl.currentPage
      offset = CGFloat(page) * pageWidth
      scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    if page != currentPage {
      currentPage = page
      Theme.shared.font = Font(rawValue: currentPage) ?? .firaSans
    }
  }
}

extension OptionsController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.isDragging || scrollView.isDecelerating {
      synchronizeViews(scrolled: true)
    }
  }
}
