//
//  ConfigFile.swift
//  LSDmate
//
//  Created by Esben von Buchwald on 12/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

class FileConfig: File {
    let filePath = Configuration.configFile
    let readError = FileError.ConfigFileNotFound
    let writeError = FileError.ConfigFileWrite
    
    func addHosts(args: [String]) throws -> Int {
        var hosts: [String] = []
        do {
            hosts = try readToArray()
        }
        catch FileError.ConfigFileNotFound {
            print("Creating \(filePath)")
        }
        let newContent = Array(Set(hosts).union(args))
        try writeFromArray(newContent)
        return newContent.count - hosts.count
    }
    
    func removeHosts(args: [String]) throws -> Int {
        let hosts = try readToArray()
        let newContent = Array(Set(hosts).subtract(args))
        try writeFromArray(newContent)
        return hosts.count - newContent.count
    }
    
    func listHosts() throws -> [String]  {
        do {
            let hosts = try readToArray()
            return hosts
        }
        catch FileError.ConfigFileNotFound {
            print("No config file found. List is empty. \(filePath)")
            return []
        }
    }
}
