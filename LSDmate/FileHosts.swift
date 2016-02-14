//
//  HostsFile.swift
//  LSDmate
//
//  Created by Esben von Buchwald on 12/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation


class FileHosts: File {
    let filePath = Configuration.hostsFile
    let readError = FileError.HostsFileNotFound
    let writeError = FileError.HostsFileWrite
    let configFile: FileConfig
    
    init(configFile: FileConfig) {
        self.configFile = configFile
    }
    
    func enable() throws {
        try disable()
        let hostsFileLines = try readToArray()
        let hosts = try configFile.listHosts()
        let newLines = [
            STARTSIGNATURE,
            "\(BLOCKIP) \(hosts.joinWithSeparator(" "))",
            ENDSIGNATURE,
        ]
        try writeFromArray(hostsFileLines + newLines)
    }
    
    
    func disable() throws {
        let hostsFileLines = try readToArray()
        var newLines: [String] = []
        var inBlock = false
        for line in hostsFileLines {
            switch line {
            case STARTSIGNATURE:
                inBlock = true
            case ENDSIGNATURE:
                inBlock = false
            default:
                if !inBlock {
                    newLines.append(line)
                }
            }
        }
        try writeFromArray(newLines)
    }
    
    func status() throws -> LSDmateStatus {
        let hostsFileLines = try readToArray()
        if hostsFileLines.indexOf(STARTSIGNATURE) != nil {
            return .On
        }
        return .Off
    }
}