//
//  ViewController.swift
//  ConcurrencyDemo
//
//  Created by Hossam Ghareeb on 11/15/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg"]

class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {

        let data = try? Data(contentsOf: URL(string: url)!)
        return UIImage(data: data!)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    var operationQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // SubCalling Operation
        class MultiplicationOperation: Operation {
            
            var inputPair: [(Int, Int)]?
            
            override func main() {
                guard let inputPair = inputPair else { return }
                for pair in inputPair{
                    let result = pair.0 * pair.1
                    print(result)
                }
            }
        }
        
        let pairOfNumbers = [(2, 3), (5, 10), (4, 5)]
        let classOp = MultiplicationOperation()
        classOp.inputPair = pairOfNumbers
        classOp.start()

    }

    @IBAction func cancelBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.operationQueue.cancelAllOperations()
    }
    
    
/*
    @IBAction func didClickOnStart(_ sender: Any) {
        operationQueue.addOperation {
            let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
            OperationQueue.main.addOperation {
                self.imageView1.image = img1
            
            }
            
        }
        operationQueue.addOperation {
            let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
            OperationQueue.main.addOperation {
                self.imageView2.image = img2
            }
        }
    }
*/
    @IBAction func didClickOnStart(_ sender: Any) {
        let blockOperation1 = BlockOperation {
            let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
            OperationQueue.main.addOperation {
                self.imageView1.image = img1
                
            }
        }
        
        operationQueue.addOperation(blockOperation1)
        blockOperation1.completionBlock = {
            print("First Image is end up with downloading cancelled\(blockOperation1.isCancelled)")
        }
        
    
        let blockOperation2 = BlockOperation {
            let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
            OperationQueue.main.addOperation {
                self.imageView2.image = img2
            }
        }
        blockOperation2.completionBlock = {
            print("Second Image is end up with downloading")
        }
        //let add dependency for operation2 to operation1 means operation1 need to be completed before start of operation2
        blockOperation2.addDependency(blockOperation1)
        
        operationQueue.addOperation(blockOperation2)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        self.sliderValueLabel.text = "\(sender.value * 100.0)"
    }

}





