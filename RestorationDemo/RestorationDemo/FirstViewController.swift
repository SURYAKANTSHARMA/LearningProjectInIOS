//
//  FirstViewController.swift
//  RestorationDemo
//
//  Created by Mac mini on 9/7/18.
//  Copyright © 2018 Mac mini. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tapToCodeVC(_ sender: UIButton) {
        let vc = FromCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
