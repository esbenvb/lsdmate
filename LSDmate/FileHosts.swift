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
    lazy var userHostsFile: FileUserHosts = FileUserHosts(hostsFile: self)
    
    init(configFile: FileConfig) {
        self.configFile = configFile
    }
    
    func enable() throws {
        try disableInternal()
        // Read the user hosts file since it's been updated by the internal disable.
        let hostsFileLines = try userHostsFile.readToArray()
        let hosts = try configFile.listHosts()
        let newLines = [
            STARTSIGNATURE,
            "\(BLOCKIP) \(hosts.joinWithSeparator(" "))",
            ENDSIGNATURE,
        ]
        try userHostsFile.writeFromArray(hostsFileLines + newLines)
        try userHostsFile.commit()
    }
    
    private func disableInternal() throws {
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
        try userHostsFile.writeFromArray(newLines)
    }
    
    func disable() throws {
        try disableInternal()
        try userHostsFile.commit()
    }
    
    func status() throws -> LSDmateStatus {
        let hostsFileLines = try readToArray()
        if hostsFileLines.indexOf(STARTSIGNATURE) != nil {
            return .On
        }
        return .Off
    }
}