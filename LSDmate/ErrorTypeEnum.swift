//
//  ErrorTypeEnum.swift
//  LSDmate
//
//  Created by Esben von Buchwald on 12/02/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

enum FileError: ErrorType {
    case HostsFileNotFound
    case HostsFileWrite
    case FileReadError
    case ConfigFileNotFound
    case ConfigFileWrite
    case UserHostsFileNotFound
    case UserHostsFileWrite
}

