

import UIKit

class InspirationsViewController: UICollectionViewController {
    
  let inspirations = Inspiration.allInspirations()
  let colors = UIColor.palette()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.decelerationRate = .fast

    if let patternImage = UIImage(named: "Pattern") {
      view.backgroundColor = UIColor(patternImage: patternImage)
    }
    collectionView?.backgroundColor = .clear
  }
    
}

extension InspirationsViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return inspirations.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: InspirationCell.reuseIdentifier, for: indexPath)
        as? InspirationCell else {
            return UICollectionViewCell()
    }
    cell.inspiration = inspirations[indexPath.item]
    return cell

  }
    
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let layout = collectionViewLayout
        as? UltravisualLayout else {
            return
    }
    
    let offset = layout.dragOffset * CGFloat(indexPath.item)
    collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
    
  }
}
