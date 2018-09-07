//
//  ViewController.swift
//  RestorationDemo
//
//  Created by Mac mini on 9/7/18.
//  Copyright © 2018 Mac mini. All rights reserved.
//

import UIKit
/*
 Encoding and decoding any relevant data necessary to reconstruct the view controller to its previous state. You haven’t done this yet, but that’s where the UIStateRestoring protocol comes in.
 **/
class ViewController: UIViewController {

    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    /*
     Every view controller with a restoration identifier will receive a call to encodeRestorableStateWithCoder(_:) of the UIStateRestoring protocol when the app is saved. Additionally, the view controller will receive a call to decodeRestorableStateWithCoder(_:) when the app is restored.
     
     */
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        /*
         Apple is quite clear that state restoration is only for archiving information needed to create view hierarchies and return the app to its original state. It’s tempting to use the provided coders to save and restore simple model data whenever the app goes into the background, but iOS discards all archived data any time state restoration fails or the user kills the app
         */
        coder.encode(`switch`.isOn, forKey: "switch")
        if let text = textField.text, !text.isEmpty {
            coder.encode(text, forKey: "textField")
        }
        
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        if let text = coder.decodeObject(forKey: "textField") {
            textField.text = text as? String
        }
        let isEnable = coder.decodeBool(forKey: "switch")
        `switch`.isOn = isEnable
    }
   

}

