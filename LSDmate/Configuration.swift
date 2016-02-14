//
//  Configuration.swift
//  LSDmate
//
//  Created by Esben von Buchwald on 12/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

let HOSTFILEPATH = "/Users/esben/etc/hosts"
let BLOCKIP = "127.0.0.1"
let BLOCKEDFILENAME = ".blockedhosts"
let STARTSIGNATURE = "#LSDmate hosts START"
let ENDSIGNATURE = "#LSDmate hosts END"

class Configuration {
    class var hostsFile: String {return sharedInstance.hostsFile}
    class var configFile: String {return sharedInstance.configFile}
    class var signature: Signature {return sharedInstance.signature}
    class var blockedIp: String {return sharedInstance.blockedIp}
    
    class var sharedInstance: Configuration {
        struct Singleton { static let instance = Configuration() }
        return Singleton.instance
    }

    let hostsFile: String
    let configFile: String
    let signature: Signature
    let blockedIp: String

    init() {
        hostsFile = HOSTFILEPATH
        configFile = "\(NSHomeDirectory())/\(BLOCKEDFILENAME)"
        signature = Signature(start: STARTSIGNATURE, end: ENDSIGNATURE)
        blockedIp = BLOCKIP
    }
    
    init(hostsFile: String, configFile: String, blockedIp: String) {
        self.hostsFile = hostsFile
        self.configFile = configFile
        self.blockedIp = blockedIp
        self.signature = Signature(start: STARTSIGNATURE, end: ENDSIGNATURE)
    }
}
