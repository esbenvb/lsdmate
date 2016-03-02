//
//  Configuration.swift
//  LSDmate
//
//  Created by Esben von Buchwald on 12/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

let HOSTFILEPATH = "/etc/hosts"
let BLOCKIP = "127.0.0.1"
let CONFIGFILE = "\(NSHomeDirectory())/.lsdmate_blockedhosts"
let USERHOSTSFILE = "\(NSHomeDirectory())/.hosts"

let STARTSIGNATURE = "#LSDmate hosts START"
let ENDSIGNATURE = "#LSDmate hosts END"

class Configuration {
    class var userHostsFile: String {return sharedInstance.userHostsFile}
    class var hostsFile: String {return sharedInstance.hostsFile}
    class var configFile: String {return sharedInstance.configFile}
    class var signature: Signature {return sharedInstance.signature}
    class var blockedIp: String {return sharedInstance.blockedIp}
    
    class var sharedInstance: Configuration {
        struct Singleton { static let instance = Configuration() }
        return Singleton.instance
    }

    let userHostsFile: String
    let hostsFile: String
    let configFile: String
    let signature: Signature
    let blockedIp: String

    
    init() {
        userHostsFile = USERHOSTSFILE
        hostsFile = HOSTFILEPATH
        configFile = CONFIGFILE
        signature = Signature(start: STARTSIGNATURE, end: ENDSIGNATURE)
        blockedIp = BLOCKIP
    }
    
    init(userHostsFile: String, hostsFile: String, configFile: String, blockedIp: String) {
        self.userHostsFile = userHostsFile
        self.hostsFile = hostsFile
        self.configFile = configFile
        self.blockedIp = blockedIp
        self.signature = Signature(start: STARTSIGNATURE, end: ENDSIGNATURE)
    }
}
