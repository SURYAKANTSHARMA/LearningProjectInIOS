

import UIKit

class InspirationCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: InspirationCell.self)
    
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var imageCoverView: UIView!
   @IBOutlet private weak var titleLabel: UILabel!

  var inspiration: Inspiration? {
    didSet {
      if let inspiration = inspiration {
        imageView.image = inspiration.backgroundImage
        titleLabel.text = inspiration.title

      }
    }
  }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        // 1
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        // 2
        let delta = 1 - (
            (featuredHeight - frame.height) / (featuredHeight - standardHeight)
        )
        
        // 3
        let minAlpha: CGFloat = 0.0
        let maxAlpha: CGFloat = 0.75
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)

    }

  
}
