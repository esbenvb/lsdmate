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
    
    @IBOutlet var mainView: MainView!
    @IBOutlet weak var modeSelector: NSSegmentedControl!
    @IBOutlet weak var addHost: NSButton!
    @IBOutlet weak var removeHost: NSButton!

    @IBOutlet weak var hostsTable: NSTableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hostsTable.setDelegate(self)
        hostsTable.setDataSource(self)
        mainView.parentViewController = self
        updateModeSelector(modeSelector)
        reloadHosts()
        
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
    
    
    
    
    
    
    @IBAction func removeHostClicked(sender: NSButton) {
        let rows = hostsTable.selectedRowIndexes
        let selectedHosts = rows.map({hosts[$0]})
        do {
            print(selectedHosts)
            try lsdmate.removeHosts(selectedHosts)
            reloadHosts()
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

    func addHost(host: String) {
        do {
            try lsdmate.addHosts([host])
            reloadHosts()
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
    
    class func hostFromUrl(urlString: String?) -> String? {
        let url = NSURL(string: urlString!)
        return url?.host
    }
        /*do {
            let matches = try NSRegularExpression(pattern: "^https?:\\/\\/([^\\/]*)", options: .CaseInsensitive).matchesInString(url, options: NSMatchingOptions(), range: NSMakeRange(0, content.characters.count))
            
            guard let range =  matches.first?.rangeAtIndex(1) else { return }
            guard let swiftRange = rangeFromNSRange(range, forString: content) else {return}
            hostName.stringValue = content.substringWithRange(swiftRange)
            
        }
        catch {
            print("regex error")
        }
        
        // Do view setup here.
    }
    func rangeFromNSRange(nsRange: NSRange, forString str: String) -> Range<String.Index>? {
        let fromUTF16 = str.utf16.startIndex.advancedBy(nsRange.location, limit: str.utf16.endIndex)
        let toUTF16 = fromUTF16.advancedBy(nsRange.length, limit: str.utf16.endIndex)
        
        
        if let from = String.Index(fromUTF16, within: str),
            let to = String.Index(toUTF16, within: str) {
                return from ..< to
        }
        
        return nil
    }*/
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