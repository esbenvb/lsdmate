//
//  main.swift
//  LSDmate-CLI
//
//  Created by Esben von Buchwald on 11/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation
import LSDmate

enum Errors: ErrorType {
    case InvalidArguments
    case MissingContentArguments
}

let lsdmate = LSDmate()

func listHosts() throws {
    let hosts = try lsdmate.listHosts()
    print("Blocked hosts:")
    for host in hosts {
        print(host)
    }
}

func showHelp() {
    print ("Usage:")
    print ("lsdmate status | start/work | stop/play ")
    print ("Configuration:")
    print ("lsdmate list | add host1 [host2, host3] | remove host1 [host2, host3] ")
    exit(0)
}

func showStatus() throws {
    let status = try lsdmate.status()
    switch status {
    case .On:
        print ("Enabled - you are working")
    case .Off:
        print("Disabled - you are playing")
        
    }
}

func startWorking() throws  {
    try lsdmate.enable()
    print("Working")
}

func stopWorking() throws {
    try lsdmate.disable()
    print("Playing")
}

func addHosts() throws {
    let args = try getRemainingArgs()
    let added = try lsdmate.addHosts(args)
    print ("Added \(added) hosts")
}

func removeHosts() throws {
    let args = try getRemainingArgs()
    let removed = try lsdmate.removeHosts(args)
    print ("Removed \(removed) hosts")
}

func getRemainingArgs() throws  -> [String] {
    var arguments: [String] = []
    for var i = 2; i < Process.arguments.count; i++ {
        arguments.append(Process.arguments[i])
    }
    if arguments.count == 0 {
        throw Errors.MissingContentArguments
    }
    let trimmedArguments = arguments.map({ $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())})
    return trimmedArguments
}

func main() {
    do {
        if Process.arguments.count < 2 {
            showHelp()
        }
        else if Process.arguments.count >= 2 {
            switch Process.arguments[1] {
            case "list":
                try listHosts()
            case "start", "work":
                try startWorking()
            case "status":
                try showStatus()
            case "stop", "play":
                try stopWorking()
            case "add":
                try addHosts()
            case "remove":
                try removeHosts()
            default:
                throw Errors.InvalidArguments
            }
        }
    }
    catch  LSDmateErrors.ReadError(let filePath) {
        print("Cannot read from \(filePath)")
        exit(1)
    }
    catch  LSDmateErrors.WriteError(let filePath) {
        print("Cannot write to \(filePath)")
        exit(1)
    }
    catch Errors.MissingContentArguments {
        print("Missing required host(s)")
        exit(2)
    }
    catch Errors.InvalidArguments {
        print("Invalid arguments")
        exit(2)
    }
    catch (let error){
        print ("Generic error: \(error)")
        exit(3)
    }
    
}