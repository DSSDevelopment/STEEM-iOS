//
//  ViewController.swift
//  STEEMiOSDemo
//
//  Created by Derek Sanchez on 8/5/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tests = Tests()
        tests.testComment()
        tests.testVote()
    }


}

