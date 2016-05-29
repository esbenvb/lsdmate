//
//  FileUserHosts.swift
//  LSDmate
//
//  Created by Esben von Buchwald on 02/03/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

class FileUserHosts: File {
    let filePath = Configuration.userHostsFile
    let readError = FileError.UserHostsFileNotFound
    let writeError = FileError.UserHostsFileWrite
    let hostsFile: FileHosts
    
    init(hostsFile: FileHosts) {
        self.hostsFile = hostsFile
    }

    // Copy
    func commit() throws -> Int32 {
        let task = NSTask()
        task.launchPath = "/usr/local/bin/LSDmate-Helper"
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
}
