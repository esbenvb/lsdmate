//
//  main.swift
//  LSDmate-CLI
//
//  Created by Esben von Buchwald on 11/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

enum ErrorCodes: ErrorType {
    case MissingContentArguments
    case HostsFileNotFound
    case HostsFileWrite
    case FileReadError
    case ConfigFileNotFound
    case ConfigFileWrite
}

let HOSTFILEPATH = "/Users/esben/etc/hosts"
let BLOCKIP = "127.0.0.1"
let BLOCKEDFILEPATH = "/Users/esben/.blockedhosts"
let STARTSIGNATURE = "#GSD-LSD hosts START"
let ENDSIGNATURE = "#GSD-LSD hosts END"

func readFileToArray(filePath: String) throws -> [String]
{
    do {
        let fileContent = try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        let lines = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        var trimmedLines = lines.map({ $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) })
        trimmedLines = trimmedLines.filter {$0.characters.count > 0}
        return trimmedLines
    } catch  {
        throw ErrorCodes.FileReadError
    }
}

func readHostsFile() throws -> [String] {
    do {
        return try readFileToArray(HOSTFILEPATH)
    } catch  {
        throw ErrorCodes.HostsFileNotFound
    }
}

func readConfigFile() throws -> [String] {
    do {
        return try readFileToArray(BLOCKEDFILEPATH)
    } catch  {
        throw ErrorCodes.ConfigFileNotFound
    }
}

func writeConfigFile(hosts: [String]) throws {
    let fileContent = hosts.joinWithSeparator("\n")
    do {
        try fileContent.writeToFile(BLOCKEDFILEPATH, atomically: true, encoding: NSUTF8StringEncoding)
    }
    catch {
        throw ErrorCodes.ConfigFileWrite
    }
}

func writeHostsFile(lines: [String]) throws {
    let fileContent = lines.joinWithSeparator("\n")
    do {
        try fileContent.writeToFile(HOSTFILEPATH, atomically: true, encoding: NSUTF8StringEncoding)
    }
    catch {
        throw ErrorCodes.HostsFileWrite
    }
}

func listHosts() {
    do {
        let hosts = try readConfigFile()
        for host in hosts {
            print(host)
        }
    } catch  ErrorCodes.ConfigFileNotFound {
        print("No hosts defined yet")
        exit(0)
    }
    catch {
        print ("ERROR")
        exit(0)
    }
}

func enableBlockedHosts() {
    do {
        disableBlockedHosts()
        let hostsFileLines = try readHostsFile()
        let hosts = try readConfigFile()
        let newLines = [
            STARTSIGNATURE,
            "\(BLOCKIP) \(hosts.joinWithSeparator(" "))",
            ENDSIGNATURE,
        ]
        try writeHostsFile(hostsFileLines + newLines)
        
    }
    catch {
        print("ERROR")
        exit(1)
    }
}

enum ScanHostsFileState: Int {
    case Inside
    case Outside
}

func disableBlockedHosts() {
    do {
        let  hostsFileLines = try readHostsFile()
        var newLines: [String] = []
        var state = ScanHostsFileState.Outside
        for line in hostsFileLines {
            switch line {
            case STARTSIGNATURE:
                state = .Inside
                
            case ENDSIGNATURE:
                state = .Outside
                
            default:
                switch(state) {
                case .Outside:
                    newLines.append(line)
                default:
                    continue
                }
            }
        }
        try writeHostsFile(newLines)
    }
    catch {
        print("ERROR")
        exit(1)
    }
}

func showHelp() {
    print ("help:")
    exit(0)
}

enum Status {
    case On
    case Off
}

func getStatus() -> Status {
    do {
        let hostsFileLines = try readHostsFile()
        if hostsFileLines.indexOf(STARTSIGNATURE) != nil {
            return .On
        }
        return .Off
    }
    catch {
        print("ERROR")
        exit(0)
    }
}

func showStatus() {
    let status = getStatus()
    switch status {
    case .On:
        print ("Enabled - you are working")
    case .Off:
        print("Disabled - you are playing")
        
    }
    print ("status:")
    exit(0)
}

func startWorking() {
    print("working")
    enableBlockedHosts()
    exit(0)
}

func stopWorking() {
    print("playing")
    disableBlockedHosts()
    exit(0)
}

func addHosts(var args: [String]) {
    do {
        let hosts = try readConfigFile()
        args = args.filter {hosts.indexOf($0) == nil}
        try writeConfigFile(hosts + args)
        print("Added \(args.count) hosts.")
    }
    catch ErrorCodes.ConfigFileNotFound {
        print("Config file not found")
        exit(1)
    }
    catch {
        print("ERROR")
        exit(1)
    }
}

func removeHosts(args: [String]) {
    do {
        var hosts = try readConfigFile()
        let origLength = hosts.count
        hosts = hosts.filter {args.indexOf($0) == nil}
        try writeConfigFile(hosts )
        print("Removed \(origLength - hosts.count) hosts.")
    }
    catch ErrorCodes.ConfigFileNotFound {
        print("Config file not found")
        exit(1)
    }
    catch {
        print("ERROR")
        exit(1)
    }
}

func getRemainingArgs() throws  -> [String] {
    var arguments: [String] = []
    for var i = 2; i < Process.arguments.count; i++ {
        arguments.append(Process.arguments[i])
    }
    if arguments.count == 0 {
        throw ErrorCodes.MissingContentArguments
    }
    let trimmedArguments = arguments.map({ $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())})
    return trimmedArguments
}

if Process.arguments.count == 1 {
    showHelp()
}
else if Process.arguments.count >= 2 {
    switch Process.arguments[1] {
    case "list":
        listHosts()
    case "start", "work":
        startWorking()
    case "status":
        showStatus()
    case "stop", "play":
        stopWorking()
    case "add":
        do {
            let args = try getRemainingArgs()
            addHosts(args)
        }
        catch {
            print("Missing required host(s)")
            exit(2)
        }
    case "remove":
        do {
            let args = try getRemainingArgs()
            removeHosts(args)
        }
        catch {
            print("Missing required host(s)")
            exit(2)
        }
    default:
        showHelp();
    }
    
}
