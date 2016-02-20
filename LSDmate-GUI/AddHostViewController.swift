//
//  AddHostViewController.swift
//  LSDmate-GUI
//
//  Created by Esben von Buchwald on 20/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Cocoa

class AddHostViewController: NSViewController {

    @IBOutlet weak var hostName: NSTextField!

    @IBAction func addButtonClicked(sender: NSButton) {
        if hostName.stringValue.isEmpty {
            return
        }
        guard let parentVc = self.presentingViewController as? ViewController else {
            print("error finding parent vc")
            return
        }
        parentVc.addHost(hostName.stringValue)
        self.presentingViewController?.dismissViewController(self)
    }
    
    @IBAction func cancelButtonPressed(sender: NSButton) {
        self.presentingViewController?.dismissViewController(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
