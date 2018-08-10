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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        executeCode()
    }
    
    func executeCode () {
        let mainQueue   = DispatchQueue.main
        let concurQueue = DispatchQueue(label: "net.ithinkdiff.app.concurr", attributes: .concurrent)
        
        func justPrint(_ num:Int){
            print(num)
            sleep(1)
        }
        
        mainQueue.async {
            concurQueue.async {
                justPrint(1)
                justPrint(2)
                justPrint(3)
            }
            justPrint(4)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didClickOnStart(_ sender: Any) {
        
        //let queue = DispatchQueue.global(qos: .userInitiated)
        let queue = DispatchQueue(label: "aSerialQueue")
        queue.sync {
            let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
            DispatchQueue.main.async {
                self.imageView1.image = img1
            }
            
        }
        
        queue.sync {
            let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
            DispatchQueue.main.async {
                self.imageView2.image = img2
            }
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        self.sliderValueLabel.text = "\(sender.value * 100.0)"
    }

}

