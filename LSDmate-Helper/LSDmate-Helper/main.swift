//
//  main.swift
//  LSDmate-Helper
//
//  Created by Esben von Buchwald on 01/03/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

let userHostsFile = "\(NSHomeDirectory())/.hosts"
let systemHostsFile = "/etc/hosts"

do {
    let fileContent = try String(contentsOfFile: userHostsFile)
    try fileContent.writeToFile(systemHostsFile, atomically: true, encoding: NSUTF8StringEncoding)
}
catch let error as NSError {
    print("error writing \(error)")
}

