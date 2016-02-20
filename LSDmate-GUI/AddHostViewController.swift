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
        
        let pasteBoard = NSPasteboard.generalPasteboard()
        
        guard let pbItems = pasteBoard.pasteboardItems else { return }
        guard let content = pbItems[0].stringForType("public.utf8-plain-text") else { return }
        do {
        let matches = try NSRegularExpression(pattern: "^https?:\\/\\/([^\\/]*)", options: .CaseInsensitive).matchesInString(content, options: NSMatchingOptions(), range: NSMakeRange(0, content.characters.count))
            
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
    }
}
