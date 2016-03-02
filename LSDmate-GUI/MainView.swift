//
//  MainView.swift
//  LSDmate-GUI
//
//  Created by Esben von Buchwald on 21/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Cocoa

class MainView: NSView {
    var droppedUrl: String?

    var parentViewController: ViewController?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.registerForDraggedTypes([NSURLPboardType])

    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.registerForDraggedTypes([NSURLPboardType])
        
        
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        return .Copy
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        guard let string = sender.draggingPasteboard().pasteboardItems?[0].stringForType("public.url") else {
            return false
        }
        droppedUrl = string
        Swift.print(droppedUrl)

        return true
    }
    
    override func concludeDragOperation(sender: NSDraggingInfo?) {
        guard let host = ViewController.hostFromUrl(droppedUrl) else {return }
        Swift.print(host)
        guard let vc = parentViewController else {return}
        vc.addHost(host)
        
    }
    

}
