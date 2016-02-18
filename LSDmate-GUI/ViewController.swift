//
//  ViewController.swift
//  LSDmate-GUI
//
//  Created by Esben von Buchwald on 11/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

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
        
    }

    @IBAction func switchMode(sender: NSSegmentedControl) {
       print(sender.selectedSegment)
    }
    
    @IBAction func addHostClicked(sender: NSButton) {
        reloadHosts()
        print(hosts)

    }
    
    @IBAction func removeHostClicked(sender: NSButton) {
        let rows = hostsTable.selectedRowIndexes
        let selectedHosts = rows.map({hosts[$0]})
        print(selectedHosts)
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    func reloadHosts() {
        hosts.append("aasdsa\(random())" )
        hostsTable.reloadData()
    }
}


extension ViewController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return hosts.count
    }
}

extension ViewController : NSTableViewDelegate {
   /*func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = hosts[row]
        
    let cellIdentifier = "host"
    let text = item
    
    if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: self) as? NSTableCellView  {
        cell.textField?.stringValue = text
        return cell
    }
    return nil
    }
   
*/
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return hosts[row]
    }

}