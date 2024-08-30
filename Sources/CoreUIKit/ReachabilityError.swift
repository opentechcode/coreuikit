//
//  ReachabilityError.swift
//  Asgl.iOS.SDK.CoreModule
//
//  Created by Davinder S Dhaliwal on 2019-10-03.
//  Copyright © 2019 Nicole Ahadi. All rights reserved.
//

import Foundation
import SystemConfiguration


public enum ReachabilityError: Error {
    case failedToCreateWithAddress(sockaddr, Int32)
    case failedToCreateWithHostname(String, Int32)
    case unableToSetCallback(Int32)
    case unableToSetDispatchQueue(Int32)
    case unableToGetFlags(Int32)
}
