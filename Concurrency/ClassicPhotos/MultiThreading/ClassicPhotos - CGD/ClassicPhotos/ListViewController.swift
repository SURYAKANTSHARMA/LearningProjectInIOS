/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreImage

let dataSourceURL = URL(string:"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")!

class ListViewController: UITableViewController {
  lazy var photos = NSDictionary(contentsOf: dataSourceURL)!
  let cache = NSCache<NSString, AnyObject>()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Classic Photos"
    cache.countLimit = 50
  }
  
  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
    return photos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) 
    let rowKey = photos.allKeys[indexPath.row] as! String
    
    var image : UIImage?
    cell.imageView?.image = nil
    
    if let image = cache.object(forKey: self.photos[rowKey] as! NSString) as? UIImage {
        cell.imageView?.image = image
        cell.textLabel?.text = rowKey
        return cell
    }
    
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    cell.accessoryView = activityIndicatorView
    activityIndicatorView.center = cell.imageView!.center
    activityIndicatorView.startAnimating()
    

    DispatchQueue.global(qos: .userInitiated).async {
        guard let imageURL = URL(string: self.photos[rowKey] as! String),
            let imageData = try? Data(contentsOf: imageURL) else {
                DispatchQueue.main.async {
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.removeFromSuperview()
                    cell.textLabel?.text = "Fail to load"
                }
                return
        }
        
        //1
        let unfilteredImage = UIImage(data:imageData)
        //2
        image = self.applySepiaFilter(unfilteredImage!)
        self.cache.setObject(image!, forKey: self.photos[rowKey] as! NSString)
        // Configure the cell...
        if image != nil {
            DispatchQueue.main.async {
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
                cell.imageView?.image = image!
            }
        }
        
        
    }
    cell.textLabel?.text = rowKey
    return cell
  }
  
  // MARK: - image processing

  func applySepiaFilter(_ image:UIImage) -> UIImage? {
    let inputImage = CIImage(data:UIImagePNGRepresentation(image)!)
    let context = CIContext(options:nil)
    let filter = CIFilter(name:"CISepiaTone")
    filter?.setValue(inputImage, forKey: kCIInputImageKey)
    filter!.setValue(0.8, forKey: "inputIntensity")

    guard let outputImage = filter!.outputImage,
      let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
        return nil
    }
    return UIImage(cgImage: outImage)
  }
}
