//
//  ViewController.swift
//  LSDmate-GUI
//
//  Created by Esben von Buchwald on 11/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Cocoa
import LSDmate

class ViewController: NSViewController {

    let lsdmate = LSDmate()
    let alert = NSAlert()
    
    enum Mode: Int {
        case Play = 0
        case Work = 1
    }
    
    var hosts = ["hej", "med", "dig"]
    
    @IBOutlet weak var modeSelector: NSSegmentedControl!
    @IBOutlet weak var addHost: NSButton!
    @IBOutlet weak var removeHost: NSButton!

    @IBOutlet weak var hostsTable: NSTableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hostsTable.setDelegate(self)
        hostsTable.setDataSource(self)
        updateModeSelector(modeSelector)
        
    }
    
    @IBAction func switchMode(sender: NSSegmentedControl) {
        do {
            switch sender.selectedSegment {
            case Mode.Play.rawValue:
                try lsdmate.disable()
            case Mode.Work.rawValue:
                try lsdmate.enable()
            default:
                return
            }
            updateModeSelector(sender)
        }
        catch LSDmateErrors.ReadError(let filePath) {
            alert.messageText = "Error"
            alert.informativeText = "read error: \(filePath)"
            alert.runModal()
            print("read error: \(filePath)")
        }
        catch LSDmateErrors.WriteError(let filePath) {
            alert.messageText = "Error"
            alert.informativeText = "write error: \(filePath)"
            alert.runModal()
        }
        catch {
            alert.messageText = "Error"
            alert.informativeText = "Unknown error"
            alert.runModal()
        }
    }
    
    @IBAction func addHostClicked(sender: NSButton) {
        reloadHosts()
        print(hosts)

    }
    
    @IBAction func removeHostClicked(sender: NSButton) {
        let rows = hostsTable.selectedRowIndexes
        let selectedHosts = rows.map({hosts[$0]})
        do {
            try lsdmate.removeHosts(selectedHosts)
            print(selectedHosts)
        }
        catch LSDmateErrors.ReadError(let filePath) {
            alert.messageText = "Error"
            alert.informativeText = "read error: \(filePath)"
            alert.runModal()
            print("read error: \(filePath)")
        }
        catch LSDmateErrors.WriteError(let filePath) {
            alert.messageText = "Error"
            alert.informativeText = "write error: \(filePath)"
            alert.runModal()
        }
        catch {
            alert.messageText = "Error"
            alert.informativeText = "Unknown error"
            alert.runModal()
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func updateModeSelector(element: NSSegmentedControl) {
        do {
            let status = try lsdmate.status()
            switch status {
            case .On:
                element.selectedSegment = Mode.Work.rawValue
            case .Off:
                element.selectedSegment = Mode.Play.rawValue
            }
        }
        catch LSDmateErrors.ReadError(let filePath) {
            alert.messageText = "Error"
            alert.informativeText = "read error: \(filePath)"
            alert.runModal()
            print("read error: \(filePath)")
        }
        catch {
            alert.messageText = "Error"
            alert.informativeText = "Unknown error"
            alert.runModal()
        }
    }
    
    func reloadHosts() {
        do {
            hosts = try lsdmate.listHosts()
            hostsTable.reloadData()
        }
        catch LSDmateErrors.ReadError(let filePath) {
            alert.messageText = "Error"
            alert.informativeText = "read error: \(filePath)"
            alert.runModal()
            print("read error: \(filePath)")
        }
        catch {
            alert.messageText = "Error"
            alert.informativeText = "Unknown error"
            alert.runModal()
        }
    }
}


extension ViewController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return hosts.count
    }
}

extension ViewController : NSTableViewDelegate {
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return hosts[row]
    }

}