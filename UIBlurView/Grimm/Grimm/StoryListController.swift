
import UIKit

class StoryListController: UITableViewController {
  
  static let segueIdentifier = "StoryListToStoryView"
  
  private var stories: [Story] = []
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    registerForNotifications()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let storyViewController = segue.destination as? StoryViewController,
      segue.identifier == StoryListController.segueIdentifier,
      let story = sender as? Story
      else { return }
    storyViewController.story = story
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let image = UIImage(named: "Bull")
    let imageView = UIImageView(image: image)
    navigationItem.titleView = imageView
    reloadTheme()
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    activityView.hidesWhenStopped = true
    let containerItem = UIBarButtonItem(customView: activityView)
    navigationItem.rightBarButtonItem = containerItem
    
    tableView.register(StoryCell.self, forCellReuseIdentifier: "StoryCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 78
    tableView.tableFooterView = UIView()
    
    activityView.startAnimating()
    Story.loadStories() { [weak self] loadedStories in
      guard let `self` = self else { return }
      self.stories = loadedStories
      let count = self.stories.count
      let indexPaths = (0..<count).map{ IndexPath(row: $0, section: 0) }
      self.tableView.beginUpdates()
      self.tableView.insertRows(at: indexPaths, with: .automatic)
      self.tableView.endUpdates()
      activityView.stopAnimating()
    }
  }
  
  func preferredContentSizeCategoryDidChange(notification: NSNotification!) {
    tableView.reloadData()
  }
  
  private func registerForNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(StoryViewController.preferredContentSizeDidChange(forChildContentContainer:)),
                                   name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    notificationCenter.addObserver(self, selector: #selector(StoryViewController.themeDidChange),
                                   name: ThemeDidChangeNotification, object: nil)
  }
  
  @objc func themeDidChange() {
    reloadTheme()
  }
  
}

extension StoryListController { // UITableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
    return stories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let storyCell = tableView.dequeueReusableCell(withIdentifier: "StoryCell") as! StoryCell
    storyCell.story = stories[indexPath.row]
    return storyCell
  }
}

extension StoryListController { // UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let story = stories[indexPath.row]
    performSegue(withIdentifier: StoryListController.segueIdentifier, sender: story)
  }
}

extension StoryListController: ThemeAdopting {
  func reloadTheme() {
    let theme = Theme.shared
    tableView.separatorColor = theme.separatorColor
    
    if let indexPaths = tableView.indexPathsForVisibleRows {
      tableView.reloadRows(at: indexPaths, with: .none)
    }
  }
}

