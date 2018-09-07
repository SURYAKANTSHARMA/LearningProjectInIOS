//
//  FromCodeViewController.swift
//  RestorationDemo
//
//  Created by Mac mini on 9/7/18.
//  Copyright © 2018 Mac mini. All rights reserved.
//

import UIKit

class FromCodeViewController: UIViewController {
    
    var color: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let redValue = CGFloat(drand48())
        let blueValue =  CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        color = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        self.view.backgroundColor = color
        restorationIdentifier = "FromCodeViewController"
        restorationClass = FromCodeViewController.self
    }

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(color, forKey: "color")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        self.color = coder.decodeObject(forKey: "color") as! UIColor
        self.view.backgroundColor = color
    }
    
}

extension FromCodeViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        return FromCodeViewController()
    }
    
}
