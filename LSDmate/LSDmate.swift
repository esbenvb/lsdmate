//
//  LSDmate.swift
//  LSDmate
//
//  Created by Esben von Buchwald on 13/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

public enum LSDmateStatus {
    case On
    case Off
}

public enum LSDmateErrors:ErrorType {
    case ReadError(filePath: String)
    case WriteError(filePath: String)
}

public class LSDmate  {
    
    public init() {
    }
    
    let hostsFile = FileHosts(configFile: FileConfig())
    
    public func enable() throws {
        do {
            try hostsFile.enable()
        }
        catch FileError.HostsFileWrite {
            throw LSDmateErrors.WriteError(filePath: Configuration.hostsFile)
        }
        catch FileError.HostsFileNotFound {
            throw LSDmateErrors.ReadError(filePath: Configuration.hostsFile)
        }
    }
    
    public func disable() throws {
        do {
            try hostsFile.disable()
        }
        catch FileError.HostsFileWrite {
            throw LSDmateErrors.WriteError(filePath: Configuration.hostsFile)
        }
        catch FileError.HostsFileNotFound {
            throw LSDmateErrors.ReadError(filePath: Configuration.hostsFile)
        }
    }
    
    public func status() throws -> LSDmateStatus {
        do {
            return try hostsFile.status()
        }
        catch FileError.HostsFileNotFound {
            throw LSDmateErrors.ReadError(filePath: Configuration.hostsFile)
        }
    }

    public func listHosts() throws -> [String] {
        do {
            return try hostsFile.configFile.listHosts()
        }
        catch FileError.ConfigFileNotFound {
            throw LSDmateErrors.ReadError(filePath: Configuration.configFile)
        }
    }
    
    public func removeHosts(hosts: [String]) throws -> Int  {
        do {
            return try hostsFile.configFile.removeHosts(hosts)
        }
        catch FileError.ConfigFileNotFound {
            throw LSDmateErrors.ReadError(filePath: Configuration.configFile)
        }
        catch FileError.ConfigFileWrite {
            throw LSDmateErrors.WriteError(filePath: Configuration.configFile)
        }
    }
    
    public func addHosts(hosts: [String]) throws -> Int  {
        do {
            return try hostsFile.configFile.addHosts(hosts)
        }
        catch FileError.ConfigFileNotFound {
            throw LSDmateErrors.ReadError(filePath: Configuration.configFile)
        }
        catch FileError.ConfigFileWrite {
            throw LSDmateErrors.WriteError(filePath: Configuration.configFile)
        }
    }
    
 /*
    public func enable() -> (() throws -> Void ) {
        func enable() throws {
            try hostsFile.enable()
        }
        return enable
    }
    
    public func disable() -> (() throws -> Void ) {
        func disable() throws {
            try hostsFile.enable()
        }
        return disable
    }
    
    public func status() -> (() throws -> LSDmateStatus ) {
        func status() throws -> LSDmateStatus{
            return try hostsFile.status()
        }
        return status
    }
    
    public func listHosts() -> (() throws -> [String] ) {
        func listHosts() throws -> [String] {
            return try hostsFile.configFile.listHosts()
        }
        return listHosts
    }
    
    public func addHosts() -> ((hosts: [String]) throws -> Void ) {
        func addHosts(hosts: [String]) throws -> Void  {
            try hostsFile.configFile.addHosts(hosts)
        }
        return addHosts
    }
    
    public func removeHosts() -> ((hosts: [String]) throws -> Void ) {
        func removeHosts(hosts: [String]) throws -> Void  {
            try hostsFile.configFile.removeHosts(hosts)
        }
        return removeHosts
    }
    
    public func execute(operation: (() throws -> Void)) throws {
        do {
            return try operation()
        }
        catch FileError.ConfigFileWrite {
            throw LSDmateErrors.WriteError(filePath: Configuration.configFile)
        }
        catch FileError.HostsFileWrite {
            throw LSDmateErrors.WriteError(filePath: Configuration.hostsFile)
        }
        catch FileError.ConfigFileNotFound {
            throw LSDmateErrors.ReadError(filePath: Configuration.hostsFile)
        }
        catch FileError.HostsFileNotFound {
            throw LSDmateErrors.ReadError(filePath: Configuration.hostsFile)
        }
    }
*/
}