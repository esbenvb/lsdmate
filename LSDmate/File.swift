//
//  File.swift
//  LSDmate
//
//  Created by Esben von Buchwald on 12/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

protocol File {
    var filePath: String {get}
    var readError: FileError {get}
    var writeError: FileError {get}
}

extension File {
    internal func readToArray() throws -> [String] {
        do {
            let fileContent = try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
            let lines = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            var trimmedLines = lines.map({ $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) })
            trimmedLines = trimmedLines.filter {$0.characters.count > 0}
            return trimmedLines
        } catch  {
            throw readError
        }
    }
    
    internal func writeFromArray(lines: [String]) throws {
        let fileContent = lines.joinWithSeparator("\n")
        do {
            try fileContent.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch {
            throw writeError
        }
    }
    
    internal func read() throws -> String {
        do {
            let fileContent = try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
            return fileContent
        } catch  {
            throw readError
        }
    }
    
    internal func write(fileContent: String) throws {
        do {
            try fileContent.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch {
            throw writeError
        }
    }
}
